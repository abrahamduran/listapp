
//
//  ShoppingListViewModel.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ShoppingListViewModel {
    private let getShoppingList: GetShoppingList
    private let updateShoppingItem: UpdateShoppingItem
    private let deleteShoppingItem: DeleteShoppingItem
    
    private let _state = BehaviorRelay<State>(value: .empty)
    let state: Driver<State>
    
    private var isSearching = false
    private var searchableList = [ShoppingItem]()
    private let _list = BehaviorRelay<[ShoppingItem]>(value: [])
    let list: Driver<[ShoppingItem]>
    
    init(getShoppingList: GetShoppingList, updateShoppingItem: UpdateShoppingItem, deleteShoppingItem: DeleteShoppingItem) {
        self.getShoppingList = getShoppingList
        self.updateShoppingItem = updateShoppingItem
        self.deleteShoppingItem = deleteShoppingItem
        
        state = _state.asDriver()
        list = _list.asDriver()
    }
    
    func getList(for user: User) {
        _state.accept(.loading)
        getShoppingList.invoke(params: user) { [unowned self] result in
            switch result {
            case .success(let list):
                self._state.accept(.success)
                self._list.accept(list)
            case .failure(let error):
                self._state.accept(.error(error))
            }
        }
    }
    
    func setItemCompleted(_ item: ShoppingItem, isCompleted: Bool, for user: User) {
        _state.accept(.loading)
        let toUpdate = ShoppingItem(id: item.id, name: item.name, isCompleted: isCompleted)
        updateShoppingItem.invoke(params: UpdateShoppingItem.Params(user: user, item: toUpdate)) { [unowned self] result in
            switch result {
            case .success(let updatedItem):
                self._state.accept(.success)
                let list = self._list.value.updating(updatedItem)
                self.searchableList.update(updatedItem)
                self._list.accept(list)
            case .failure(let error):
                self._state.accept(.error(error))
            }
        }
    }
    
    func delete(item: ShoppingItem, for user: User) {
        _state.accept(.loading)
        deleteShoppingItem.invoke(params: DeleteShoppingItem.Params(user: user, item: item)) { [unowned self] result in
            switch result {
            case .success(let deletedItem):
                self._state.accept(.success)
                self.searchableList.remove(deletedItem)
                let list = self._list.value.removing(deletedItem)
                self._list.accept(list)
            case .failure(let error):
                self._state.accept(.error(error))
            }
        }
    }
    
    func search(query: String) {
        guard query.isNotEmpty else {
            cancelSearch() ; return
        }
        if !isSearching {
            searchableList = _list.value
        }
        isSearching = true
        
        // Strip out all the leading and trailing spaces.
        let strippedString = query.trimmingCharacters(in: .whitespaces)
        
        let results = searchableList.filter {
            $0.name.range(of: strippedString, options: [.caseInsensitive, .diacriticInsensitive]) != nil ||
            $0.description.range(of: strippedString, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        }
        
        _list.accept(results)
    }
    
    private func cancelSearch() {
        guard isSearching else { return }
        isSearching = false
        _list.accept(searchableList)
        searchableList.removeAll()
    }
}

extension ShoppingListViewModel {
    enum State {
        case empty, loading, success, error(Error)
    }
}

extension Array where Element == ShoppingItem {
    mutating func remove(_ item: ShoppingItem) {
        guard let index = firstIndex(where: { $0.id == item.id }) else { return }
        remove(at: index)
    }
    
    func removing(_ item: ShoppingItem) -> [ShoppingItem] {
        var list = self
        list.remove(item)
        return list
    }
    
    mutating func update(_ item: ShoppingItem) {
        guard let index = firstIndex(where: { $0.id == item.id }) else { return }
        self[index] = item
    }
    
    func updating(_ item: ShoppingItem) -> [ShoppingItem] {
        var list = self
        list.update(item)
        return list
    }
}
