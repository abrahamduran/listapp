//
//  AddShoppingItemViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/20/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

class AddShoppingItemViewController: UIViewController {
    @IBOutlet weak var newItemTextField: UITextField!
    @IBOutlet weak var addItemButton: UIButton!

    private let disposeBag = DisposeBag()
    
    var viewModel: AddShoppingItemViewModel!
    
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
        
        viewModel.state.drive(onNext: { [weak self] state in
            if state.isNotLoading {
                self?.stopAnimating()
            }
            switch state {
            case .loading:
                self?.startAnimating()
            case .error(let error):
                self?.presentAlert(for: error)
            case .success(let item):
                self?.navigateToHome(sender: item)
                self?.newItemTextField.text = ""
            default:
                self?.newItemTextField.text = ""
            }
        }).disposed(by: disposeBag)
        newItemTextField.rx.text.orEmpty.bind(to: viewModel.itemName).disposed(by: disposeBag)
        newItemTextField.rx.text.orEmpty.map({ $0.isNotEmpty })
        .bind(to: addItemButton.rx.isEnabled)
        .disposed(by: disposeBag)
    }
    
    @IBAction func addItemAction(_ sender: UIButton) {
        dismissKeyboard()
        viewModel.addItem(for: user)
    }
}

// MARK: UITextFieldDelegate
extension AddShoppingItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddShoppingItemViewController: NVActivityIndicatorViewable { }

private extension AddShoppingItemViewController {
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func navigateToHome(sender: ShoppingItem) {
        tabBarController?.selectedIndex = 0
        let vc = tabBarController?.selectedViewController as? ShoppingListViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            vc?.viewModel.addItem(sender)
        }
    }
}
