//
//  SignUp.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class SignUp: UseCase {
    typealias Output = User
    typealias Input = Params
    
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func handle(params: SignUp.Params) -> Result<User, Error> {
        guard emailIsValid(params.user.email) else {
            return .failure(ApplicationError.invalidEmail)
        }
        guard passwordIsValid(params.password) else {
            return .failure(ApplicationError.invalidPassword)
        }
        var result: Result<User, Error>!
        let group = DispatchGroup()
        group.enter()
        service.signUp(user: params.user, password: params.password) { _result in
            result = _result
            group.leave()
        }
        
        group.wait()
        return result
    }
    
    private func emailIsValid(_ email: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil
    }
    
    private func passwordIsValid(_ password: String) -> Bool {
        // Back4App password's rules: must contain a capital letter,
        // lowercase letter, a number and be at least 8 characters long.
        let regex = try! NSRegularExpression(pattern: "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{7,}", options: .caseInsensitive)
        return regex.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) != nil
    }
}

extension SignUp {
    struct Params {
        let user: User
        let password: String
    }
}
