//
//  LargeTabBar.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

@IBDesignable
class LargeTabBar: UITabBar {
    private let kTabBarHeight: CGFloat = 128
    
    override var cornerRadius: CGFloat {
        set {
            topRadius = newValue
        }
        get {
            return topRadius
        }
    }
    
    @IBInspectable
    public var topRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
            layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
        get {
            return layer.cornerRadius
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var _size = super.sizeThatFits(size)
        _size.height = kTabBarHeight
        
        return _size
    }
}
