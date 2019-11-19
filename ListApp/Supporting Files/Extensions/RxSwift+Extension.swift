//
//  RxSwift+Extension.swift
//  MediaDownloader
//
//  Created by Abraham Isaac Durán on 11/8/18.
//  Copyright © 2018 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// Two way binding operator between control property and relay, that's all it takes.
infix operator <-> : DefaultPrecedence

func <-> (property: ControlProperty<Any>, relay: BehaviorRelay<Any>) -> Disposable {
    let bindToUIDisposable = relay.bind(to: property)
    let bindToRelay = property
        .subscribe(onNext: { n in
            relay.accept(n)
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToRelay)
}
