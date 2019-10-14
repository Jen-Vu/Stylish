//
//  TapPayViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/30.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import KeychainAccess

class TapPayViewController: UIViewController {

    @IBOutlet weak var conformButton: UIButton!
    @IBOutlet weak var infoContent: UIView!
    var tpdCard: TPDCard!
    var tpdForm: TPDForm!
    var orderInfo: OrderInfo?
    let orderCheckOut = OrderCheckOut()
    
    @IBAction func conformButton(_ sender: UIButton) {
        tpdCard = TPDCard.setup(tpdForm)
        
        tpdCard.onSuccessCallback { (prime, cardInfo, cardIdentifier) in
            
            print(cardInfo)
            print(cardIdentifier)
            
            guard let prime = prime, let orderInfo = self.orderInfo else { return }
            
            let orderCheckOutInfo = OrderCheckOutInfo(prime: prime, orderInfo: orderInfo)
            
            let keychain = Keychain(service: "com.littlema.STYLiSH")
            let token = keychain["stylishToken"]
            
            guard let tokenValue = token else { return }
            
            self.orderCheckOut.postOrderCheckOut(token: tokenValue, orderData: orderCheckOutInfo)

            }.onFailureCallback { (status, message) in
                
                let result = "status : \(status),\n message : \(message)"
                
                print(result)
                
            }.getPrime()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("CreditCardInfo", comment: "")
        
        tpdForm = TPDForm.setup(withContainer: infoContent)
        
        tpdForm.setErrorColor(.init(hexString: "#D62D20"))
        tpdForm.setOkColor(.init(hexString: "#008744"))
        tpdForm.setNormalColor(.init(hexString: "#0F0F0F"))
        
        tpdForm.onFormUpdated { (status) in

            weak var weakSelf = self
            
            weakSelf?.conformButton.isEnabled = status.isCanGetPrime()
            weakSelf?.conformButton.alpha = (status.isCanGetPrime()) ? 1.0 : 0.4
            
        }
        
        orderCheckOut.dataPassHelper.handler = { (result) in
            if result {
                guard let nextController = self.storyboard?.instantiateViewController(
                    withIdentifier: "FinishedCheckoutVC") as? FinishedCheckoutViewController
                    else { return }
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(nextController, animated: true)
                }
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }

}
