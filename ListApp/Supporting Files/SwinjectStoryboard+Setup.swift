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
//            c.viewModel = r.resolve(LoginViewModel.self)!
        }
//        defaultContainer.register(LoginViewModel.self) { r in
//            LoginViewModel(userService: r.resolve(UserService.self)!,
//                           organizationService: r.resolve(OrganizationService.self)!)
//        }
        
        // MARK: Sign Up
        defaultContainer.storyboardInitCompleted(SignUpViewController.self) { (r, c) in
            c.viewModel = r.resolve(SignUpViewModel.self)
        }
        defaultContainer.register(SignUpViewModel.self) { r in
            SignUpViewModel(usecase: r.resolve(SignUp.self)!)
        }
        
        // MARK: Use Cases
        defaultContainer.register(SignUp.self) { r in
            SignUp(service: r.resolve(UserService.self)!)
        }.inObjectScope(.weak)
        
        // MARK: Services
        defaultContainer.register(UserService.self) { _ in
            B4AUserService()
        }.inObjectScope(.weak)
    }
}
