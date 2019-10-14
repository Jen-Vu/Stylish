//
//  MainTabBarController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/27.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onNotification(notification:)),
            name: ShoppingCartViewController.notificationName,
            object: nil)
        
        if let tabItems = self.tabBar.items {
            let tabItem = tabItems[2]
            let count = storageManager.shoppingCartListCount
            tabItem.badgeColor = .tabBarTint
            tabItem.badgeValue = count == 0 ? nil : "\(count)"
        }
    }
    
    @objc func onNotification(notification: Notification) {
        let data = notification.userInfo
        guard let count = data?["count"] as? String else { return }
        if let tabItems = self.tabBar.items {
            let tabItem = tabItems[2]
            tabItem.badgeColor = .tabBarTint
            tabItem.badgeValue = count == "0" ? nil : count
        }
    }
}
