//
//  ShoppingItem.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/17/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

struct ShoppingItem {
    let id: String
    let name: String
    let isCompleted: Bool
    
    var description: String {
        return isCompleted ? "Completed" : "Missing"
    }
}
