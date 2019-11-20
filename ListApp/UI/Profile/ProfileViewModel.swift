//
//  ProfileViewModel.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/20/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Parse
import RxCocoa
import RxSwift

class ProfileViewModel {
    private let usecase: UpdateUserProfile
    
    private let _state = BehaviorRelay<State>(value: .empty)
    let state: Driver<State>
    
    let email = BehaviorRelay<String>(value: "")
    let fullName = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    let passwordVefirication = BehaviorRelay<String>(value: "")
    
    var isValid: Observable<Bool> {
        return Observable.combineLatest(
            isPasswordValid,
            email.asObservable().map({ $0.isNotEmpty }),
            fullName.asObservable().map({ $0.isNotEmpty })
        ) { $0 && $1 && $2 }
    }
    
    private var isPasswordValid: Observable<Bool> {
        return Observable.combineLatest(password.asObservable(), passwordVefirication.asObservable()) {
            $0.isNotEmpty && $1.isNotEmpty && $0 == $1
        }
    }
    
    init(usecase: UpdateUserProfile) {
        self.usecase = usecase
        self.state = _state.asDriver()
    }
    
    func update() {
        _state.accept(.loading)
        let user = User(id: "", email: email.value, fullName: fullName.value)
        usecase.invoke(params: UpdateUserProfile.Params(user: user, password: password.value)) { [weak self] result in
            switch result {
            case .success(let user):
                self?._state.accept(.success(user))
            case .failure(let error):
                self?._state.accept(.error(error))
            }
        }
    }
    
    func logout() {
        PFUser.logOutInBackground()
    }
}

extension ProfileViewModel {
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
