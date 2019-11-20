//
//  ShoppingListViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import NVActivityIndicatorView
import RxCocoa
import RxSwift
import UIKit

class ShoppingListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!

    private let disposeBag = DisposeBag()
    
    var viewModel: ShoppingListViewModel!
    var user: User {
        if let u = (tabBarController as? ListAppTabBarController)?.user {
            return u
        } else {
            // This should be considered as a weird condition, since this should never happen
            return User(id: "", email: "", fullName: "")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshItems), for: .valueChanged)
        tableView.tableFooterView = UIView()
        
        let datasource = RxSimpleAnimatableDataSource<ShoppingItem, ShoppingItemTableViewCell>(identifier: "item-cell") { _, data, cell in
            cell.item = data
            cell.delegate = self
        }
        
        viewModel.list
        .asObservable()
        .bind(to: tableView.rx.items(dataSource: datasource))
        .disposed(by: disposeBag)
        
        viewModel.state.drive(onNext: { [weak self] state in
            switch state {
            case .loading:
                if self?.tableView.refreshControl?.isRefreshing == false {
                    self?.startAnimating()
                }
            case .error(let error):
                self?.stopAnimating()
                self?.tableView.refreshControl?.endRefreshing()
                self?.presentAlert(for: error)
            default:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.tableView.refreshControl?.endRefreshing()
                }
                self?.stopAnimating()
            }
        }).disposed(by: disposeBag)
        
        searchTextField.rx.text.orEmpty
        .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        .subscribe(onNext: { [weak self] text in
            self?.viewModel.search(query: text)
        }).disposed(by: disposeBag)
        
        viewModel.getList(for: user)
    }
    
    @IBAction func editModeAction(_ sender: UIButton) {
        if tableView.isEditing {
            sender.setTitle("Editar", for: .normal)
        } else {
            sender.setTitle("Terminar", for: .normal)
        }
        
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
}

// MARK: ShoppingItemCellDelegate
extension ShoppingListViewController: ShoppingItemCellDelegate {
    func setItemCompleted(_ item: ShoppingItem, isCompleted: Bool) {
        viewModel.setItemCompleted(item, isCompleted: isCompleted, for: user)
    }
    
    func deleteItem(_ item: ShoppingItem) {
        let vc = UIAlertController(title: "Delete this item?", message: "Are you sure you want to delete \(item.name)?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.delete(item: item, for: self.user)
        }
        vc.addAction(okAction)
        vc.addAction(deleteAction)
        vc.preferredAction = okAction
        vc.view.tintColor = .primary
        present(vc, animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate
extension ShoppingListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ShoppingListViewController: NVActivityIndicatorViewable { }

private extension ShoppingListViewController {
    @objc func refreshItems() {
        viewModel.getList(for: user)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
