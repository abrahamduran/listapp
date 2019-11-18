//
//  UIView+Extension.swift
//  MediaDownloader
//
//  Created by Abraham Isaac Durán on 9/9/18.
//  Copyright © 2018 Abraham Isaac Durán. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    @IBInspectable
    public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}

extension UIView {
//    func fade(toAlpha alpha: CGFloat, withDuration duration: TimeInterval = FADE_IN_DURATION) {
//        guard alpha > 0 else { return }
//        UIView.animate(withDuration: duration, animations: {
//            self.alpha = alpha
//        })
//    }
//
//    func fadeIn(withDuration duration: TimeInterval = FADE_IN_DURATION) {
//        guard alpha < 1.0 || isHidden else { return }
//        isHidden = false ; alpha = 0.0
//        UIView.animate(withDuration: duration) { self.alpha = 1.0 }
//    }
//
//    func fadeOut(withDuration duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
//        guard alpha > 0.5 || !isHidden else { return }
//        UIView.animate(withDuration: duration, animations: { self.alpha = 0.0 })
//        { _ in self.isHidden = true ; completion?() }
//    }
    
    func bounce() {
        guard layer.animation(forKey: "bounce") == nil else { return }
        let animation = CABasicAnimation(keyPath: "transform")
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = 0.125
        animation.toValue = CATransform3DMakeScale(1.4, 1.4, 1.0)
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.isRemovedOnCompletion = true
        
        layer.add(animation, forKey: "bounce")
    }
}
