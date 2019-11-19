//
//  Errors.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

enum ApplicationError: LocalizedError {
    case unknown, invalidPassword, invalidEmail
    
    var localizedDescription: String {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address (e.g. janesmith@mail.com)"
        case .invalidPassword:
            return "Please enter a valid password. Passwords must contain a capital letter, lowercase letter, a number and be at least 8 characters long."
        case .unknown:
            return "Something went wrong on our side."
        }
    }
    
    var errorDescription: String? { return localizedDescription }
}
