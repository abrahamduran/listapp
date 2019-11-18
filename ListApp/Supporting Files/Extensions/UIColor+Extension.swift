//
//  UIColor+Extension.swift
//  MediaDownloader
//
//  Created by Abraham Isaac Durán on 9/9/18.
//  Copyright © 2018 Abraham Isaac Durán. All rights reserved.
//

import UIKit

extension UIColor {
    static var primary: UIColor {
        guard let color = UIColor(named: "primary") else {
            fatalError("Primary color was not found or defined. Please, define a primary color in the Assets.xcassets file")
        }
        return color
    }
    static var secondary: UIColor {
        guard let color = UIColor(named: "secondary") else {
            fatalError("Secondary color was not found or defined. Please, define a secondary color in the Assets.xcassets file")
        }
        return color
    }
}
