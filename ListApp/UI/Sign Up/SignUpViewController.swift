//
//  SignUpViewController.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func dismiss(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
