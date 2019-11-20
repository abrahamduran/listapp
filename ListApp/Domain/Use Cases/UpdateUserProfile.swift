//
//  UpdateUserProfile.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/20/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class UpdateUserProfile: UseCase {
    typealias Output = User
    typealias Input = Params
    
    private let service: UserService
    
    init(service: UserService) {
        self.service = service
    }
    
    func handle(params: Params) -> Result<User, Error> {
        var result: Result<User, Error>!
        let group = DispatchGroup()
        group.enter()
        service.update(user: params.user, password: params.password) { _result in
            result = _result
            group.leave()
        }
        
        group.wait()
        return result
    }
}

extension UpdateUserProfile {
    struct Params {
        let user: User
        let password: String
    }
}
