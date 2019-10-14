//
//  CheckViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/28.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Kingfisher
import FBSDKLoginKit
import FacebookLogin
import KeychainAccess

enum PaymentData: String {
    case creditCard = "credit_card"
    case cash = "cash"
}

class CheckViewController: UIViewController {
    
    let header = [
        NSLocalizedString("OrderProducts", comment: ""),
        NSLocalizedString("RecipientInfo", comment: ""),
        NSLocalizedString("PaymentMethod", comment: "")]
    var shoppingCartList: [ShoppingCart]?
    var recipientInfo: RecipientInfo?
    var paymentInfo = PaymentData.cash.rawValue
    var checkoutButton: UIButton?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(STOrderProductCell.nib, forCellReuseIdentifier: STOrderProductCell.identifier)
        tableView.register(STOrderUserInputCell.nib, forCellReuseIdentifier: STOrderUserInputCell.identifier)
        tableView.register(
            STPaymentInfoTableViewCell.nib,
            forCellReuseIdentifier: STPaymentInfoTableViewCell.identifier)
        tableView.register(STOrderHeaderView.nib, forHeaderFooterViewReuseIdentifier: STOrderHeaderView.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func recipientInfoIsEmpty(recipientInfo: RecipientInfo?) -> Bool {
        guard let recipientInfo = recipientInfo,
            recipientInfo.name != "",
            recipientInfo.email != "",
            recipientInfo.phone != "",
            recipientInfo.address != "",
            recipientInfo.time != ""
        else { return false }
        
        return true
    }
    
    func checkPaymentInfoIsEmpty(paymentInfo: String?) -> Bool {
        
        guard let paymentInfo = paymentInfo else { return false }
        
        if paymentInfo == PaymentData.cash.rawValue || paymentInfo == PaymentData.creditCard.rawValue {
            return true
        }

        return false
    }
    
    func checkoutButtonIsAvailable(_ isAvailable: Bool) {
        guard let checkoutButton = checkoutButton else { return }
        if isAvailable {
            checkoutButton.isEnabled = true
            checkoutButton.backgroundColor = .greyStylish
        } else {
            checkoutButton.isEnabled = false
            checkoutButton.backgroundColor = .shoppingCartButtonUnavailable
        }

    }
    
    func getSubTotal() -> Int {
        var subTotal = 0
        
        guard let shoppingCartList = shoppingCartList else { return 0 }
        
        for orderProduct in shoppingCartList {
            subTotal += Int(orderProduct.price)
        }
        return subTotal
    }

}

extension CheckViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 67.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: STOrderHeaderView.identifier) as? STOrderHeaderView else {
            return nil
        }
        
        headerView.titleLabel.text = header[section]
        headerView.backgroundColor = .white
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        
        guard let footerView = view as? UITableViewHeaderFooterView else { return }
        
        footerView.contentView.backgroundColor = UIColor.init(hexString: "cccccc")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? storageManager.shoppingCartListCount : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell

        if indexPath.section == 0 {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: STOrderProductCell.identifier,
                for: indexPath)
            
            guard let productCell = cell as? STOrderProductCell,
                let data = storageManager.shoppingCartList[indexPath.row] as? ShoppingCart,
                let color = data.colorCode,
                let mainImage = data.mainImage else {
                return cell
            }

            productCell.productTitleLabel.text = data.title
            productCell.colorView.backgroundColor = .init(hexString: color)
            productCell.productSizeLabel.text = data.size
            productCell.orderNumberLabel.text = "x \(data.quantity)"
            productCell.priceLabel.text = Int(data.price).transNTMoneyStyle(locale: .zh_TW)
            productCell.productImageView.kf.setImage(with: URL(string: mainImage))
            
            return productCell
        } else if indexPath.section == 1 {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: STOrderUserInputCell.identifier,
                for: indexPath)
            
            guard let userInputCell = cell as? STOrderUserInputCell else {
                return cell
            }
            
            userInputCell.delegate = self
            
        } else {
            
            cell = tableView.dequeueReusableCell(
                withIdentifier: STPaymentInfoTableViewCell.identifier,
                for: indexPath)
            
            guard let paymentCell = cell as? STPaymentInfoTableViewCell, let shoppingCartList = shoppingCartList else {
                return cell
            }
            
            paymentCell.layoutCellWith(productPrice: getSubTotal(), shipPrice: 50, productCount: shoppingCartList.count)
            
            paymentCell.delegate = self
            
            checkoutButton = paymentCell.checkoutButton
        }
        
        return cell
    }
}

extension CheckViewController: STOrderUserInputCellDelegate {
    func didChangeUserData(
        _ cell: STOrderUserInputCell,
        username: String,
        email: String,
        phoneNumber: String,
        address: String,
        shipTime: String) {
        
        recipientInfo = RecipientInfo(
            name: username,
            phone: phoneNumber,
            email: email,
            address: address,
            time: shipTime)
        
        guard recipientInfoIsEmpty(recipientInfo: recipientInfo), checkPaymentInfoIsEmpty(paymentInfo: paymentInfo)
        else {
            checkoutButtonIsAvailable(false)
            return
        }
        
        checkoutButtonIsAvailable(true)
        print(username, email, phoneNumber, address, shipTime)

    }
    
}

extension CheckViewController: STPaymentInfoTableViewCellDelegate {
    
    func didChangePaymentMethod(_ cell: STPaymentInfoTableViewCell) {
        
        tableView.reloadData()
    }
    
    func didChangeUserData(
        _ cell: STPaymentInfoTableViewCell,
        payment: String,
        cardNumber: String,
        dueDate: String,
        verifyCode: String
        ) {
        
        paymentInfo = payment
        
        guard recipientInfoIsEmpty(recipientInfo: recipientInfo), checkPaymentInfoIsEmpty(paymentInfo: paymentInfo)
        else {
            checkoutButtonIsAvailable(false)
            return
        }
        
        checkoutButtonIsAvailable(true)
        print(payment, cardNumber, dueDate, verifyCode)
    }
    
    func checkout(_ cell: STPaymentInfoTableViewCell) {
        
        print("=============")
        print("User did tap checkout button")
        
        guard let recipientInfo = recipientInfo, let shoppingCartList = shoppingCartList else { return }
        
        let orderInfo = OrderInfo(
            payment: paymentInfo,
            subtotal: getSubTotal(),
            freight: 50,
            total: getSubTotal() + 50,
            recipient: recipientInfo, orderProducts: shoppingCartList)
        
        let keychain = Keychain(service: "com.littlema.STYLiSH")
        let token = keychain["stylishToken"]
        
        if token != nil { //Tip: FB 判斷是否登入過 func -> let token = AccessToken.current
            if paymentInfo == PaymentData.creditCard.rawValue {
                guard let nextController = storyboard?.instantiateViewController(
                    withIdentifier: "TapPayVC") as? TapPayViewController
                    else { return }
                nextController.orderInfo = orderInfo
                navigationController?.pushViewController(nextController, animated: true)
            } else if paymentInfo == PaymentData.cash.rawValue {
                guard let nextController = storyboard?.instantiateViewController(
                    withIdentifier: "FinishedCheckoutVC") as? FinishedCheckoutViewController
                    else { return }
                navigationController?.pushViewController(nextController, animated: true)
            }
        } else {
            guard let nextController = storyboard?.instantiateViewController(
                withIdentifier: "LoginViewController") as? LoginViewController
            else { return }
            nextController.modalPresentationStyle = .overCurrentContext
            present(nextController, animated: true, completion: nil)
        }
        
    }
    
}
