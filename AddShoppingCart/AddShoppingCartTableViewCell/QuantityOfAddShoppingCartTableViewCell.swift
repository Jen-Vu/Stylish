//
//  QuantityShoppingCartTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class QuantityOfAddShoppingCartTableViewCell: UITableViewCell {
    
    var item: AddShoppingCartItem? {
        didSet {
            guard let item = item as? QuantityShoppingCartItem else { return }
            viewModel = item.viewModel
        }
    }
    var viewModel: AddShoppingCartViewModel? {
        didSet {
            viewModel?.helper.passMaxQuantity = { stock in
                self.stock = stock
            }
        }
    }
    var stock: Int? {
        didSet {
            if let maxQuantity = stock {
                currentQuantity = 1
                
                stockLabel.text = String.localizedStringWithFormat(NSLocalizedString("CurrentStock", comment: ""), maxQuantity)
                //"庫存：\(maxQuantity)"
                textfield.text = "\(currentQuantity!)"
                textfield.isUserInteractionEnabled = true
                textfield.layer.borderColor = UIColor.greyStylish.cgColor
                textfield.textColor = UIColor.greyStylish
            } else {
                currentQuantity = nil
                initButtonStatus()
            }
        }
    }
    var currentQuantity: Int? {
        willSet {
            currentQuantity == 1 ? setMinusButtonStatus(true) : setMinusButtonStatus(false)
            currentQuantity == stock ? setAddButtonStatus(true) : setAddButtonStatus(false)
        }
        didSet {
            currentQuantity == stock ? setAddButtonStatus(false) : setAddButtonStatus(true)
            currentQuantity == 1 ? setMinusButtonStatus(false) : setMinusButtonStatus(true)
            guard let quantity = currentQuantity else { return }
            viewModel?.selectQuantity = "\(quantity)"
        
            guard let viewController = viewModel?.viewController as? AddShoppingCartViewController else { return }
            viewController.addToShoppingCartIsAvailable(true)
        }
    }

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    @IBAction func addButton(_ sender: UIButton) {
    
        guard var currentQuantity = currentQuantity, let maxQuantity = stock else { return }
        
        if currentQuantity < maxQuantity {
            currentQuantity += 1
            self.currentQuantity = currentQuantity
            textfield.text = "\(currentQuantity)"
        }
        
    }
    
    @IBAction func minusButton(_ sender: UIButton) {
        
        guard var currentQuantity = currentQuantity else { return }
        
        if currentQuantity > 1 {
            currentQuantity -= 1
            self.currentQuantity = currentQuantity
            textfield.text = "\(currentQuantity)"
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textfield.delegate = self
        
        addButton.layer.borderWidth = 1.0
        minusButton.layer.borderWidth = 1.0
        textfield.layer.cornerRadius = 0
        textfield.layer.borderWidth = 1.0
        textfield.keyboardType = .numberPad
        textfield.textAlignment = .center
        textfield.font = .systemFont(ofSize: 14)
        nameLabel.text = NSLocalizedString("CurrentQuantity", comment: "")
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = .lightGreyStylish
        stockLabel.textColor = .lightGreyStylish
        initButtonStatus()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initButtonStatus() {
        setAddButtonStatus(false)
        setMinusButtonStatus(false)
        textfield.layer.borderColor = UIColor.greyStylishTransparent(for: 0.4).cgColor
        textfield.text = ""
        textfield.textColor = UIColor.greyStylishTransparent(for: 0.4)
        textfield.isUserInteractionEnabled = false
        stockLabel.text = ""
        guard let viewController = viewModel?.viewController as? AddShoppingCartViewController else { return }
        viewController.addToShoppingCartIsAvailable(false)
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

extension QuantityOfAddShoppingCartTableViewCell: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
        
        guard let stringNumber = textField.text,
            let number = Int(stringNumber),
            let inputNumber = Int(string),
            let maxQuantity = stock
        else {
            return false
        }
        
        if number * 10 * stringNumber.count + inputNumber >= maxQuantity {
            textField.text = "\(maxQuantity)"
            return false
        }
        
        return true
    }
}
