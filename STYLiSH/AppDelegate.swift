//
//  AppDelegate.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData
import FBSDKCoreKit
import AdSupport

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        self.window!.tintColor = UIColor.tintStylish
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.greyStylish]
        UINavigationBar.appearance().titleTextAttributes =
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)]

        UITabBar.appearance().barTintColor = UIColor.white
        
        //For IQKeyboard use
        IQKeyboardManager.shared.enable = true
        
        //For CoreData use
        //Tip: 可查虛擬機 SQLite 位置
        //print(NSPersistentContainer.defaultDirectoryURL())
        let results = storageManager.selectAll(entity: "ShoppingCart")
        
        storageManager.shoppingCartList = results ?? [NSManagedObject]()
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
//        //For TapPay Use
        TPDSetup.setWithAppId(
            12348,
            withAppKey: "app_pa1pQcKoY22IlnSXq5m5WP5jFKzoRG58VEXpT7wU62ud7mMbDOGzCYIlzzLF",
            with: TPDServerType.sandBox)

        TPDSetup.shareInstance().setupIDFA(ASIdentifierManager.shared().advertisingIdentifier.uuidString)

        TPDSetup.shareInstance().serverSync()

        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:])
    -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //storageManager.saveContext()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        //storageManager.saveContext()
    }
    
    //Tip: 等於把 STYLiSH.xcdatamodeld 放到 persistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        //Tip: name 等於 DataModel 的名稱
        let container = NSPersistentContainer(name: "STYLiSH")
        //Tip: _ = storeDescription
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}
