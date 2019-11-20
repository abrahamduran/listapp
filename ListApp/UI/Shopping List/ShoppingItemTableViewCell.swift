//
//  ShoppingItemTableViewCell.swift
//  ListApp
//
//  Created by Abraham Isaac Durán on 11/19/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import UIKit

protocol ShoppingItemCellDelegate: class {
    func setItemCompleted(_ item: ShoppingItem, isCompleted: Bool)
    func deleteItem(_ item: ShoppingItem)
}

class ShoppingItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: ShoppingItemCellDelegate?
    var item: ShoppingItem! {
        didSet {
            configure(with: item)
        }
    }
    
    @IBAction func completeAction(_ sender: UIButton) {
        let isCompleted = !item.isCompleted
        delegate?.setItemCompleted(item, isCompleted: isCompleted)
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        delegate?.deleteItem(item)
    }
    
    override func setEditing(_ isEditing: Bool, animated: Bool) {
        if isEditing {
            deleteButton.fadeIn()
        } else {
            deleteButton.fadeOut()
        }
    }
}

private extension ShoppingItemTableViewCell {
    func configure(with item: ShoppingItem) {
        itemLabel.text = item.name
        let image = UIImage(
            systemName: item.isCompleted ? "x.square" : "square",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 24,
                weight: .bold
            )
        )
        completeButton.setImage(image, for: .normal)
    }
}
