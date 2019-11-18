//
//  RoundedTextField.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/17/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

@IBDesignable
final class RoundedTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 16)
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override var leftView: UIView? {
        didSet {
            leftView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
            leftView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
            super.leftView = leftView
        }
    }
    override var backgroundColor: UIColor? {
        didSet {
            backgroundView.backgroundColor = backgroundColor
            super.backgroundColor = backgroundColor
        }
    }
    
    @IBInspectable var leftViewIcon: UIImage? {
        didSet {
            guard let ic = leftViewIcon else { return }
            leftView = UIImageView(image: ic)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += 16
        return rect
    }
}

private extension RoundedTextField {
    func setup() {
        leftViewMode = .always
    }
}
