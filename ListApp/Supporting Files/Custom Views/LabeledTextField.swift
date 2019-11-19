//
//  LabeledTextField.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/18/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

@IBDesignable
final class LabeledTextField: UITextField {
    let padding = UIEdgeInsets(top: 32, left: 32, bottom: 0, right: 16)
    private lazy var titleViewWidthAnchor: NSLayoutConstraint = {
        return titleView.widthAnchor.constraint(equalToConstant: 120)
    }()
    private lazy var titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @IBInspectable var title: String? = "" {
        didSet {
            titleLabel.text = title
            titleLabel.sizeToFit()
            setLabelViewWidth()
        }
    }
    
    @IBInspectable var titleViewRightOffset: CGFloat = 0 {
        didSet {
            setLabelViewWidth()
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

private extension LabeledTextField {
    func setup() {
//        leftViewMode = .always
//        leftView = UIImageView(image: UIImage(named: "selected-icon"))
//        layer.cornerRadius = 20
//        if isSecureTextEntry {
//            rightView = revealButton
//            rightViewMode = .whileEditing
//        }
//
        
        titleView.addSubview(titleLabel)
        addSubview(titleView)
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: titleView.leftAnchor, constant: padding.left),
            titleView.leftAnchor.constraint(equalTo: leftAnchor),
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            titleViewWidthAnchor
        ])
        setLabelViewWidth()
//
//        addSubview(errorLabel)
//        NSLayoutConstraint.activate([
//            errorLabel.leftAnchor.constraint(equalTo: leftAnchor),
//            errorLabel.rightAnchor.constraint(equalTo: rightAnchor),
//            errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 4)
//        ])
    }
    
    func setLabelViewWidth() {
        let width = padding.left + titleLabel.frame.width + titleViewRightOffset + 8 // constant offset of 8 px
        titleViewWidthAnchor.constant = width
    }
}
