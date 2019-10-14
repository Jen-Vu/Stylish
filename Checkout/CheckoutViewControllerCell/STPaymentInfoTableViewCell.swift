//
//  STPaymentInfoTableViewCell.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/7/26.
//  Copyright © 2019 WU CHIH WEI. All rights reserved.
//

import UIKit

private enum PaymentMethod: String {
    
    case creditCard = "CreditCard"
    
    case cash = "Cash"
    
    public func localized(args: CVarArg...) -> String {
        let localizedString = NSLocalizedString(self.rawValue, comment: "")
        return String.init(format: localizedString, args)
    }
}

protocol STPaymentInfoTableViewCellDelegate: AnyObject {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell)
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
    )
    
    func checkout(_ cell: STPaymentInfoTableViewCell)
}

class STPaymentInfoTableViewCell: UITableViewCell {
    
    let paymentDict = [NSLocalizedString("CreditCard", comment: ""): "credit_card", NSLocalizedString("Cash", comment: ""): "cash"]

    @IBOutlet weak var paymentTextField: UITextField! {
        
        didSet {
        
            let shipPicker = UIPickerView()
            
            shipPicker.dataSource = self
            
            shipPicker.delegate = self
            
            paymentTextField.inputView = shipPicker
            
            let button = UIButton(type: .custom)
            
            button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            
            button.setBackgroundImage(
                UIImage.asset(.Icons_24px_DropDown),
                for: .normal
            )
            
            button.isUserInteractionEnabled = false
            
            paymentTextField.rightView = button
            
            paymentTextField.rightViewMode = .always
            
            paymentTextField.delegate = self
            
            paymentTextField.text = PaymentMethod.cash.localized()
        }
    }
    
    @IBOutlet weak var cardNumberTextField: UITextField! {
        
        didSet {
            
            cardNumberTextField.delegate = self
        }
    }
    
    @IBOutlet weak var dueDateTextField: UITextField! {
        
        didSet {
            
            dueDateTextField.delegate = self
        }
    }
    
    @IBOutlet weak var verifyCodeTextField: UITextField! {
        
        didSet {
            
            verifyCodeTextField.delegate = self
        }
    }
    
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var shipPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var topDistanceConstraint: NSLayoutConstraint!
    @IBOutlet weak var creditView: UIView! {
        
        didSet {
            creditView.isHidden = true
        }
    }
    
    @IBOutlet weak var checkoutButton: UIButton!
    
    private let paymentMethod: [PaymentMethod] = [.cash, .creditCard]
    
    weak var delegate: STPaymentInfoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func layoutCellWith(
        productPrice: Int,
        shipPrice: Int,
        productCount: Int
    ) {
        
        productPriceLabel.text = productPrice.transNTMoneyStyle(locale: .zh_TW)
        shipPriceLabel.text = shipPrice.transNTMoneyStyle(locale: .zh_TW)
        totalPriceLabel.text = (productPrice + shipPrice).transNTMoneyStyle(locale: .zh_TW)
        productAmountLabel.text = String.localizedStringWithFormat(NSLocalizedString("ProductQuauntity", comment: ""), productCount)
        //"總計 (\(productCount)樣商品)"
    }

    @IBAction func checkout() {
        
        delegate?.checkout(self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private func getEnumTypeData(text: String) -> PaymentMethod? {
        if text == PaymentMethod.cash.localized() {
            return .cash
        } else if text == PaymentMethod.creditCard.localized() {
            return .creditCard
        }
        
        return nil
    }
    
}

extension STPaymentInfoTableViewCell: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return 2
    }
    
    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        
        return paymentMethod[row].localized()
    }
}

extension STPaymentInfoTableViewCell: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        paymentTextField.text = paymentMethod[row].localized()
    }
    
    private func manipulateHeight(_ distance: CGFloat) {
        
        topDistanceConstraint.constant = distance
        
        delegate?.didChangePaymentMethod(self)
    }
}

extension STPaymentInfoTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField != paymentTextField {

            passData()
            //Tip:
            return
        }
        
        guard
            let text = textField.text,
            let payment = getEnumTypeData(text: text)
            else
        {
            
            passData()
            
            return
        }
        
        switch payment {
            
        case .cash:
            
            manipulateHeight(44)
            
            creditView.isHidden = true
            
        case .creditCard:
            
            //manipulateHeight(228)
            manipulateHeight(44)
            
            creditView.isHidden = true
        }
        
        passData()
        
    }
    
    private func passData() {
        
        guard
            let paymentMethod = paymentTextField.text,
            let cardNumber = cardNumberTextField.text,
            let dueDate = dueDateTextField.text,
            let verifyCode = verifyCodeTextField.text else
        {
            return
        }
        
        guard let paymentData = paymentDict[paymentMethod] else { return }
        
        delegate?.didChangeUserData(
            self,
            payment: paymentData,
            cardNumber: cardNumber,
            dueDate: dueDate,
            verifyCode: verifyCode
        )
        
    }
}
