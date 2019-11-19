//
//  UIViewController+Extension .swift
//  MediaDownloader
//
//  Created by Abraham Isaac Durán on 12/26/18.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(for error: Error) {
        let vc = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        vc.addAction(okAction)
        vc.preferredAction = okAction
        vc.view.tintColor = .primary
        present(vc, animated: true, completion: nil)
    }
}
