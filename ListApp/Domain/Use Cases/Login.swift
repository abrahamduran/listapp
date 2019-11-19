//
//  Login.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class Login: UseCase {
    typealias Output = User
    typealias Input = Params
    
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func handle(params: Params) -> Result<User, Error> {
        guard emailIsValid(params.email) else {
            return .failure(ApplicationError.invalidEmail)
        }
        var result: Result<User, Error>!
        let group = DispatchGroup()
        group.enter()
        service.login(email: params.email, password: params.password) { _result in
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
}

extension Login {
    struct Params {
        let email: String
        let password: String
    }
}
