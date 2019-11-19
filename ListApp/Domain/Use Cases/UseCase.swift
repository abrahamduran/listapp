//
//  UseCase.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

protocol UseCase: class {
    associatedtype Output
    associatedtype Input
    
    func handle(params: Input) -> Result<Output, Error>
    func invoke(params: Input, completion: @escaping (Result<Output, Error>) -> Void)
}

extension UseCase {
    func invoke(params: Input, completion: @escaping (Result<Output, Error>) -> Void) {
        DispatchQueue.usecase.async { [weak self] in
            guard let self = self else { return }
            let result = self.handle(params: params)
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
