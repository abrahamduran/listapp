//
//  ShoppingListService.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Parse

protocol ShoppingListService {
    typealias ListCompletionHandler = (Result<[ShoppingItem], Error>) -> Void
    typealias CompletionHandler = (Result<ShoppingItem, Error>) -> Void
    func getList(for user: User, completion: @escaping ListCompletionHandler)
    func add(item: ShoppingItem, for user: User, completion: @escaping CompletionHandler)
    func update(item: ShoppingItem, for user: User, completion: @escaping CompletionHandler)
    func delete(item: ShoppingItem, for user: User, completion: @escaping CompletionHandler)
}

class B4AShoppingListService: ShoppingListService {
    func getList(for user: User, completion: @escaping ListCompletionHandler) {
        let query = PFQuery(className: "ShoppingItem")
        query.whereKey("userId", equalTo: user.id)
        query.order(byAscending: "createdAt")
        query.findObjectsInBackground { (results, error) in
            if let results = results {
                let items = results.map(ShoppingItem.init)
                completion(.success(items))
            } else {
                completion(.failure(error ?? ApplicationError.unknown))
            }
        }
    }
    
    func add(item: ShoppingItem, for user: User, completion: @escaping CompletionHandler) {
        let object = PFObject(className:"ShoppingItem")
        
        object["name"] = item.name
        object["userId"] = user.id
        object["isCompleted"] = item.isCompleted
        
        // Saves the new object.
        object.saveInBackground { (success, error) in
            if success {
                completion(.success(ShoppingItem(with: object)))
            } else {
                completion(.failure(error ?? ApplicationError.unknown))
            }
        }
    }
    
    func update(item: ShoppingItem, for user: User, completion: @escaping CompletionHandler) {
        let query = PFQuery(className:"ShoppingItem")
        
        query.getObjectInBackground(withId: item.id) { (object, error) in
            if let object = object {
                object["isCompleted"] = item.isCompleted
                object.saveInBackground { (success, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(ShoppingItem(with: object)))
                    }
                }
            } else {
                completion(.failure(error ?? ApplicationError.unknown))
            }
        }
    }
    
    func delete(item: ShoppingItem, for user: User, completion: @escaping CompletionHandler) {
        let query = PFQuery(className:"ShoppingItem")
        
        query.getObjectInBackground(withId: item.id) { (object, error) in
            if let object = object {
                object.deleteInBackground { (success, error) in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(ShoppingItem(with: object)))
                    }
                }
            } else {
                completion(.failure(error ?? ApplicationError.unknown))
            }
        }
    }
}

extension ShoppingItem {
    init(with object: PFObject) {
        self.id = object.objectId ?? ""
        self.name = (object["name"] as? String) ?? ""
        self.isCompleted = (object["isCompleted"] as? Bool) ?? false
    }
}
