//
//  LoginViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var nextTextField: [UITextField: UITextField] = [:]
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        bindUI()
        
        viewModel.state.drive(onNext: { [weak self] state in
            if state.isNotLoading {
                self?.stopAnimating()
            }
            switch state {
            case .loading:
                self?.startAnimating()
            case .success(let user):
                self?.performSegue(withIdentifier: "showHome", sender: user)
            case .error(let error):
                self?.presentAlert(for: error)
            case .empty: break
            }
        }).disposed(by: disposeBag)
        
        [emailTextField, passwordTextField].forEach { $0?.delegate = self}
        nextTextField[emailTextField] = passwordTextField
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? LoginViewController else { return }
        guard let user = sender as? User else { return }
        
//        vc.viewModel.user = user
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        viewModel.login()
    }
}

// MARK: UIGestureRecognizerDelegate
extension LoginViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if(navigationController!.viewControllers.count > 1){
            return true
        }
        return false
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tf = nextTextField[textField] {
            tf.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController: NVActivityIndicatorViewable { }

private extension LoginViewController {
    func bindUI() {
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        viewModel.isValid.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
