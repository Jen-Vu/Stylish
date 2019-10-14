//
//  ShoppingCartViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Toast_Swift

class AddShoppingCartViewController: UIViewController {
    
    var viewModel: AddShoppingCartViewModel?
    var product: Product? {
        didSet {
            guard let product = product else { return }
            viewModel = AddShoppingCartViewModel(product: product, viewController: self)
            
            if mainTableView != nil {
                mainTableView.dataSource = viewModel
            }
        }
    }

    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.clipsToBounds = true
            mainTableView.layer.cornerRadius = 20
            mainTableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            mainTableView.register(
                TitleOfAddShoppingCartTableViewCell.nib,
                forCellReuseIdentifier: TitleOfAddShoppingCartTableViewCell.identifier)
            mainTableView.register(
                ColorOfAddShoppingCartTableViewCell.nib,
                forCellReuseIdentifier: ColorOfAddShoppingCartTableViewCell.identifier)
            mainTableView.register(
                SizeOfAddShoppingCartTableViewCell.nib,
                forCellReuseIdentifier: SizeOfAddShoppingCartTableViewCell.identifier)
            mainTableView.register(
                QuantityOfAddShoppingCartTableViewCell.nib,
                forCellReuseIdentifier: QuantityOfAddShoppingCartTableViewCell.identifier)
            
            if viewModel != nil {
                mainTableView.dataSource = viewModel
            }
        }
    }
    @IBOutlet weak var addShoppingCartButton: UIButton!
    
    @IBAction func addShoppingCart(_ sender: UIButton) {
        guard let viewModel = viewModel,
            let orderProduct = viewModel.getOrderContent() else { return }
        
        storageManager.insertShoppingCartProduct(entity: "ShoppingCart", orderProduct: orderProduct)
        self.view.makeToast(NSLocalizedString("AddSuccess", comment: ""), duration: 1.0, position: .center)
        
        NotificationCenter.default.post(
            name: ShoppingCartViewController.notificationName,
            object: nil,
            userInfo: ["count": "\(storageManager.shoppingCartListCount)"])
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.disMissShoppingCart()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addToShoppingCartIsAvailable(false)
           
    }
    
    func addToShoppingCartIsAvailable(_ status: Bool) {
        addShoppingCartButton.backgroundColor = status ? .greyStylish : .shoppingCartButtonUnavailable
        addShoppingCartButton.isEnabled = status ? true : false
    }
    
    func disMissShoppingCart() {
        dismiss(animated: true, completion: nil)
    }
    
}
