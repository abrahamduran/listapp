//
//  GetShoppingList.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

class GetShoppingList: UseCase {
    typealias Output = [ShoppingItem]
    typealias Input = User
    
    private let service: ShoppingListService
    
    init(service: ShoppingListService) {
        self.service = service
    }
    
    func handle(params: User) -> Result<[ShoppingItem], Error> {
        var result: Result<[ShoppingItem], Error>!
        let group = DispatchGroup()
        group.enter()
        service.getList(for: params) { _result in
            result = _result
            group.leave()
        }
        
        group.wait()
        return result
    }
}
