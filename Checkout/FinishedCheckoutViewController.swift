//
//  FinishedCheckoutViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/29.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class FinishedCheckoutViewController: UIViewController {

    let leftBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        return barButtonItem
    }()
    
    @IBAction func backMainPage(_ sender: UIButton) {
        if self.presentingViewController != nil {
            self.dismiss(animated: false, completion: {
                self.navigationController!.popToRootViewController(animated: true)
            })
        } else {
            let window = (UIApplication.shared.delegate as? AppDelegate)?.window
            let tabBar: MainTabBarController? =  window?.rootViewController as? MainTabBarController
            tabBar?.selectedIndex = 0
            
            storageManager.clearShoppingCart()
            NotificationCenter.default.post(
                name: ShoppingCartViewController.notificationName,
                object: nil,
                userInfo: ["count": "\(storageManager.shoppingCartListCount)"])
            
            self.navigationController!.popToRootViewController(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("CheckoutInfo", comment: "")
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
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
