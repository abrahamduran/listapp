//
//  ViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/17/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        PFUser.getCurrentUserInBackground().continueWith { [weak self] task in
            if let user = task.result {
                self?.navigateTo(segue: "showHome", sender: User(with: user))
            } else {
                self?.navigateTo(segue: "showLogin", sender: nil)
            }
            
            return task
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? ListAppTabBarController else { return }
        guard let user = sender as? User else { return }
        
        vc.user = user
    }
    
    func navigateTo(segue: String, sender: Any?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: segue, sender: sender)
        }
    }
}
