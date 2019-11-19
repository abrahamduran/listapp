//
//  LoginViewModel.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel {
    private let usecase: Login
    
    private let _state = BehaviorRelay<State>(value: .empty)
    let state: Driver<State>
    
    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(
            email.asObservable().map({ $0.isNotEmpty }),
            password.asObservable().map({ $0.isNotEmpty })
        ) { $0 && $1 }
    }
    
    init(usecase: Login) {
        self.usecase = usecase
        
        state = _state.asDriver()
    }
    
    func login() {
        _state.accept(.loading)
        usecase.invoke(params: Login.Params(email: email.value, password: password.value)) { [unowned self] result in
            switch result {
            case .success(let user): self._state.accept(.success(user))
            case .failure(let error): self._state.accept(.error(error))
            }
        }
    }
}

extension LoginViewModel {
    enum State {
        case empty, loading, success(User), error(Error)
        
        var isNotLoading: Bool {
            switch self {
            case .loading: return false
            default: return true
            }
        }
    }
}
