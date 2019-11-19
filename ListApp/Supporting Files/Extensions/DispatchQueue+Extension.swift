//
//  DispatchQueue+Extension.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/4/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation

extension DispatchQueue {
    static let usecase = DispatchQueue(label: "\(Bundle.main.bundleIdentifier ?? "listapp").networking", qos: .utility, attributes: .concurrent)
}
