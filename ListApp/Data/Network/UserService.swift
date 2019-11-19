//
//  UserService.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/17/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Parse

protocol UserService {
    typealias CompletionHandler = (Result<User, Error>) -> Void
    func login(email: String, password: String, completion: @escaping CompletionHandler)
    func signUp(user: User, password: String, completion: @escaping CompletionHandler)
    func update(user: User, password: String, completion: @escaping CompletionHandler)
}

class B4AUserService: UserService {
    func login(email: String, password: String, completion: @escaping CompletionHandler) {
        PFUser.logInWithUsername(inBackground: email, password: password) { (user, error) in
            if let user = user {
                completion(.success(User(with: user)))
            } else {
                completion(.failure(error ?? ApplicationError.unknown))
            }
        }
    }

    func signUp(user: User, password: String, completion: @escaping CompletionHandler) {
        let _user = PFUser()
        _user.username = user.email
        _user.email = user.email
        _user.password = password
        
        _user.signUpInBackground { (success, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(User(with: _user)))
            }
        }
    }

    func update(user: User, password: String, completion: @escaping CompletionHandler) {
        PFUser.getCurrentUserInBackground().continueWith { task in
            if let _user = task.result {
                _user.email = user.email
                _user.username = user.email
                _user["fullName"] = user.fullName
                _user.saveInBackground { (success, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(User(with: _user)))
                    }
                }
            } else {
                completion(.failure(task.error ?? ApplicationError.unknown))
            }
            
            return task.result
        }
    }
}

extension User {
    init(with user: PFUser) {
        self.id = user.objectId ?? ""
        self.email = user.email ?? ""
        self.fullName = (user["fullName"] as? String) ?? ""
    }
}
