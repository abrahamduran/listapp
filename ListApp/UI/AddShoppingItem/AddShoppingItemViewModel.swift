//
//  AddShoppingItemViewModel.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/20/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AddShoppingItemViewModel {
    private let usecase: AddNewShoppingItem
    
    private let _state = BehaviorRelay<State>(value: .empty)
    let state: Driver<State>
    
    let itemName = BehaviorRelay<String>(value: "")
    
    init(usecase: AddNewShoppingItem) {
        self.usecase = usecase
        
        state = _state.asDriver()
    }
    
    func addItem(for user: User) {
        _state.accept(.loading)
        let item = ShoppingItem(id: "", name: itemName.value, isCompleted: false)
        usecase.invoke(params: AddNewShoppingItem.Params(user: user, item: item)) { [weak self] result in
            switch result {
            case .success(let newItem):
                self?._state.accept(.success(newItem))
            case .failure(let error):
                self?._state.accept(.error(error))
            }
        }
    }
}

extension AddShoppingItemViewModel {
    enum State {
        case empty, loading, success(ShoppingItem), error(Error)
        
        var isNotLoading: Bool {
            switch self {
            case .loading: return false
            default: return true
            }
        }
    }
}
