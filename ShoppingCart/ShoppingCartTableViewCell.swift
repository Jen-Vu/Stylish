//
//  ShoppingCartTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/25.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ShoppingCartTableViewCell: UITableViewCell {
    
    var tapQuantityAction: ((ShoppingCartTableViewCell, Int) -> Void)?
    var tapDeleteAction: ((ShoppingCartTableViewCell) -> Void)?

    var stock: Int?
    var currentQuantity: Int? {
        willSet {
//            currentQuantity == 1 ? setMinusButtonStatus(true) : setMinusButtonStatus(false)
//            currentQuantity == stock ? setAddButtonStatus(true) : setAddButtonStatus(false)
        }
        didSet {
//            currentQuantity == stock ? setAddButtonStatus(false) : setAddButtonStatus(true)
//            currentQuantity == 1 ? setMinusButtonStatus(false) : setMinusButtonStatus(true)
            guard let currentQuantity = currentQuantity else { return }
            quantityLabel.text = "\(currentQuantity)"
        }
    }
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var separationLine: UIView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func tapAddQuantity(_ sender: UIButton) {
        guard var currentQuantity = currentQuantity else { return }
        currentQuantity += 1
        self.currentQuantity = currentQuantity
        tapQuantityAction?(self, currentQuantity)
    }
    
    @IBAction func tapMinusQuantity(_ sender: UIButton) {
        guard var currentQuantity = currentQuantity else { return }
        currentQuantity -= 1
        self.currentQuantity = currentQuantity
        tapQuantityAction?(self, currentQuantity)
    }
    
    @IBAction func tapDelete(_ sender: UIButton) {
        tapDeleteAction?(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separationLine.backgroundColor = .separateLineStylish
        removeButton.setTitleColor(.unselectGreyStylish, for: .normal)
        removeButton.setTitle(NSLocalizedString("Remove", comment: ""), for: .normal)
        sizeLabel.textColor = .greyStylish
        priceLabel.textColor = .greyStylish
        addButton.layer.borderWidth = 1.0
        minusButton.layer.borderWidth = 1.0
        quantityLabel.layer.borderWidth = 1.0
        quantityLabel.layer.borderColor = UIColor.greyStylish.cgColor
        initButtonStatus()
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame = newFrame
            frame.origin.x += 16
            frame.origin.y += 12
            frame.size.width -= 2 * 16
            super.frame = frame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initButtonStatus() {
        setAddButtonStatus(true)
        setMinusButtonStatus(true)
        productImageView.image = UIImage(named: DefaultContent.image.rawValue)
        titleLabel.text = DefaultContent.string.rawValue
        colorView.backgroundColor = .shoppingCartCellUnavailable
        sizeLabel.text = DefaultContent.none.rawValue
        priceLabel.text = DefaultContent.none.rawValue
        quantityLabel.text = "1"
    }
    
    func setAddButtonStatus(_ isAvailable: Bool) {
        if isAvailable {
            addButton.layer.borderColor = UIColor.greyStylish.cgColor
            addButton.imageView?.alpha = 1
            addButton.isEnabled = true
        } else {
            addButton.layer.borderColor = UIColor.greyStylishTransparent(for: 0.4).cgColor
            addButton.imageView?.alpha = 0.4
            addButton.isEnabled = false
        }
    }
    
    func setMinusButtonStatus(_ isAvailable: Bool) {
        if isAvailable {
            minusButton.layer.borderColor = UIColor.greyStylish.cgColor
            minusButton.imageView?.alpha = 1
            minusButton.isEnabled = true
        } else {
            minusButton.layer.borderColor = UIColor.greyStylishTransparent(for: 0.4).cgColor
            minusButton.imageView?.alpha = 0.4
            minusButton.isEnabled = false
        }
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
