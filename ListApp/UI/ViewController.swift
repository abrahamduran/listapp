//
//  ViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/17/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        performSegue(withIdentifier: "showLogin", sender: nil)
    }
}
