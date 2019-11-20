//
//  ProfileViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/20/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordVerificationTextField: UITextField!
    @IBOutlet weak var saveProfileButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var nextTextField: [UITextField: UITextField] = [:]
    
    var viewModel: ProfileViewModel!
    var user: User {
        if let u = (tabBarController as? ListAppTabBarController)?.user {
            return u
        } else {
            // This should be considered as a weird condition, since this should never happen
            return User(id: "", email: "", fullName: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        bindUI()
        
        viewModel.state.drive(onNext: { [weak self] state in
            if state.isNotLoading {
                self?.stopAnimating()
            }
            switch state {
            case .loading:
                self?.startAnimating()
            case .success(let user):
                (self?.tabBarController as? ListAppTabBarController)?.user = user
            case .error(let error):
                self?.presentAlert(for: error)
            case .empty: break
            }
        }).disposed(by: disposeBag)
        
        nextTextField[fullNameTextField] = emailTextField
        nextTextField[emailTextField] = passwordTextField
        nextTextField[passwordTextField] = passwordVerificationTextField
    }
    
    @IBAction func updateProfileAction(_ sender: UIButton) {
        dismissKeyboard()
        viewModel.update()
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        dismissKeyboard()
        viewModel.logout()
        let vc = self.presentingViewController as? ViewController
        tabBarController?.dismiss(animated: true) {
            vc?.navigateTo(segue: "showLogin", sender: nil)
        }
    }
}

// MARK: UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let tf = nextTextField[textField] {
            tf.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension ProfileViewController: NVActivityIndicatorViewable { }

private extension ProfileViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func bindUI() {
        fullNameTextField.text = user.fullName
        fullNameTextField.rx.text.orEmpty.bind(to: viewModel.fullName).disposed(by: disposeBag)
        emailTextField.text = user.email
        emailTextField.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        passwordTextField.rx.text.orEmpty.bind(to: viewModel.password).disposed(by: disposeBag)
        passwordVerificationTextField.rx.text.orEmpty.bind(to: viewModel.passwordVefirication).disposed(by: disposeBag)
        viewModel.isValid.bind(to: saveProfileButton.rx.isEnabled).disposed(by: disposeBag)
    }
}
