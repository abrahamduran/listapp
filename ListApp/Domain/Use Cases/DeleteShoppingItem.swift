//
//  DeleteShoppingItem.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class DeleteShoppingItem: UseCase {
    typealias Output = ShoppingItem
    typealias Input = Params
    
    private let service: ShoppingListService
    
    init(service: ShoppingListService) {
        self.service = service
    }
    
    func handle(params: Params) -> Result<ShoppingItem, Error> {
        var result: Result<ShoppingItem, Error>!
        let group = DispatchGroup()
        group.enter()
        service.delete(item: params.item, for: params.user) { _result in
            result = _result
            group.leave()
        }
        
        group.wait()
        return result
    }
}

extension DeleteShoppingItem {
    struct Params {
        let user: User
        let item: ShoppingItem
    }
}
