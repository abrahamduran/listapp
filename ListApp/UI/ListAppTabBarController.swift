//
//  ListAppTabBarController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

class ListAppTabBarController: UITabBarController {
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

extension ListAppTabBarController: UITabBarControllerDelegate  {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        }
        
        return true
    }
}
