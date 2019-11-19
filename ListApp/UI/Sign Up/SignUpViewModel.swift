//
//  SignUpViewModel.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SignUpViewModel {
    private let usecase: SignUp
    
    private let _state = BehaviorRelay<State>(value: .empty)
    let state: Driver<State>
    
    let email = BehaviorRelay<String>(value: "")
    let fullName = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let passwordVefirication = BehaviorRelay<String>(value: "")
    let tosAccepted = BehaviorRelay<Bool>(value: false)
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(
            isPasswordValid,
            tosAccepted.asObservable().map({ $0 }),
            email.asObservable().map({ $0.isNotEmpty }),
            fullName.asObservable().map({ $0.isNotEmpty })
        ) { $0 && $1 && $2 && $3 }
    }
    
    private var isPasswordValid: Observable<Bool> {
        return Observable.combineLatest(password.asObservable(), passwordVefirication.asObservable()) {
            $0.isNotEmpty && $1.isNotEmpty && $0 == $1
        }
    }
    
    init(usecase: SignUp) {
        self.usecase = usecase
        
        state = _state.asDriver()
    }
    
    func signUp() {
        _state.accept(.loading)
        let user = User(id: "", email: email.value, fullName: fullName.value)
        usecase.invoke(params: SignUp.Params(user: user, password: password.value)) { [unowned self] result in
            switch result {
            case .success(let user): self._state.accept(.success(user))
            case .failure(let error): self._state.accept(.error(error))
            }
        }
    }
}

extension SignUpViewModel {
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
