//
//  SwinjectStoryboard+Setup.swift
//  MediaDownloader
//
//  Created by Abraham Isaac Durán on 9/25/18.
//  Copyright © 2018 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc static func setup() {
        // MARK: Login
        defaultContainer.storyboardInitCompleted(LoginViewController.self) { (r, c) in
            c.viewModel = r.resolve(LoginViewModel.self)!
        }
        defaultContainer.register(LoginViewModel.self) { r in
            LoginViewModel(usecase: r.resolve(Login.self)!)
        }
        
        // MARK: Sign Up
        defaultContainer.storyboardInitCompleted(SignUpViewController.self) { (r, c) in
            c.viewModel = r.resolve(SignUpViewModel.self)
        }
        defaultContainer.register(SignUpViewModel.self) { r in
            SignUpViewModel(usecase: r.resolve(SignUp.self)!)
        }
        
        // MARK: Shopping List
        defaultContainer.storyboardInitCompleted(ShoppingListViewController.self) { (r, c) in
            c.viewModel = r.resolve(ShoppingListViewModel.self)
        }
        defaultContainer.register(ShoppingListViewModel.self) { r in
            ShoppingListViewModel(
                getShoppingList: r.resolve(GetShoppingList.self)!,
                updateShoppingItem: r.resolve(UpdateShoppingItem.self)!,
                deleteShoppingItem: r.resolve(DeleteShoppingItem.self)!
            )
        }
        
        // MARK: Add Shopping Item
        defaultContainer.storyboardInitCompleted(AddShoppingItemViewController.self) { (r, c) in
            c.viewModel = r.resolve(AddShoppingItemViewModel.self)
        }
        defaultContainer.register(AddShoppingItemViewModel.self) { r in
            AddShoppingItemViewModel(usecase: r.resolve(AddNewShoppingItem.self)!)
        }
        
        // MARK: Use Cases
        defaultContainer.register(SignUp.self) { r in
            SignUp(service: r.resolve(UserService.self)!)
        }.inObjectScope(.weak)
        defaultContainer.register(Login.self) { r in
            Login(service: r.resolve(UserService.self)!)
        }.inObjectScope(.weak)
        defaultContainer.register(GetShoppingList.self) { r in
            GetShoppingList(service: r.resolve(ShoppingListService.self)!)
        }.inObjectScope(.weak)
        defaultContainer.register(UpdateShoppingItem.self) { r in
            UpdateShoppingItem(service: r.resolve(ShoppingListService.self)!)
        }.inObjectScope(.weak)
        defaultContainer.register(DeleteShoppingItem.self) { r in
            DeleteShoppingItem(service: r.resolve(ShoppingListService.self)!)
        }.inObjectScope(.weak)
        defaultContainer.register(AddNewShoppingItem.self) { r in
            AddNewShoppingItem(service: r.resolve(ShoppingListService.self)!)
        }.inObjectScope(.weak)
        
        // MARK: Services
        defaultContainer.register(UserService.self) { _ in
            B4AUserService()
        }.inObjectScope(.weak)
        defaultContainer.register(ShoppingListService.self) { _ in
            B4AShoppingListService()
        }.inObjectScope(.weak)
    }
}
