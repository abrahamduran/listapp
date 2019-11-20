//
//  SignUpViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var acceptToSSwitch: UISwitch!
    @IBOutlet weak var createAccountButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var nextTextField: [UITextField: UITextField] = [:]
    
    var viewModel: SignUpViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        [fullNameTextField, emailTextField,
         passwordTextField, passwordVerificationTextField].forEach { $0?.delegate = self}
        nextTextField[fullNameTextField] = emailTextField
        nextTextField[emailTextField] = passwordTextField
        nextTextField[passwordTextField] = passwordVerificationTextField
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ListAppTabBarController else { return }
        guard let user = sender as? User else { return }
        
        vc.user = user
    }

    @IBAction func createAccountAction(_ sender: UIButton) {
        viewModel.signUp()
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tf = nextTextField[textField] {
            tf.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignUpViewController: NVActivityIndicatorViewable { }

private extension SignUpViewController {
    func bindUI() {
        fullNameTextField.rx.text.orEmpty.bind(to: viewModel.fullName).disposed(by: disposeBag)
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        passwordVerificationTextField.rx.text.orEmpty.bind(to: viewModel.passwordVefirication).disposed(by: disposeBag)
        acceptToSSwitch.rx.isOn.bind(to: viewModel.tosAccepted).disposed(by: disposeBag)
        viewModel.isValid.bind(to: createAccountButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
