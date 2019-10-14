//
//  ShoppingCartViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/24.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Kingfisher

class ShoppingCartViewController: UIViewController {
    
    static let notificationName = Notification.Name("myNotificationName")
    
    @IBOutlet weak var goCheckButton: UIButton!
    @IBOutlet weak var mainTableView: UITableView! {
        didSet {
            mainTableView.dataSource = self
            mainTableView.register(
                ShoppingCartTableViewCell.nib,
                forCellReuseIdentifier: ShoppingCartTableViewCell.identifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mainTableView.reloadData()
        
        goCheckIsAvailable(storageManager.shoppingCartListCount > 0)
    }
    
    func deleteDataFor(_ index: IndexPath) {
        storageManager.deleteShoppingCartProduct(entity: "ShoppingCart", index: index.row)
        mainTableView.deleteRows(at: [index], with: .fade)
    }
    
    func goCheckIsAvailable(_ status: Bool) {
        goCheckButton.backgroundColor = status ? .greyStylish : .shoppingCartButtonUnavailable
        goCheckButton.isEnabled = status ? true : false
    }

}

extension ShoppingCartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storageManager.shoppingCartList.isEmpty ? 0 : storageManager.shoppingCartList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainTableView.dequeueReusableCell(
            withIdentifier: ShoppingCartTableViewCell.identifier,
            for: indexPath) as? ShoppingCartTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.tapQuantityAction = { (cell, currentQuantity) in
            let indexPath = tableView.indexPath(for: cell)
            guard let index = indexPath?.row else { return }
            let prodcut = storageManager.shoppingCartList[index]
            prodcut.setValue(Int32(currentQuantity), forKey: "quantity")
            storageManager.saveContext()
        }
        
        cell.tapDeleteAction = { (cell) in
            let indexPath = tableView.indexPath(for: cell)
            guard let indexPathValue = indexPath else { return }
            self.deleteDataFor(indexPathValue)
            
            let count = storageManager.shoppingCartListCount
            NotificationCenter.default.post(
                name: ShoppingCartViewController.notificationName,
                object: nil,
                userInfo: ["count": "\(count)"])
        }
        
        if !storageManager.shoppingCartList.isEmpty,
            let data = storageManager.shoppingCartList[indexPath.row] as? ShoppingCart,
            let color = data.colorCode,
            let mainImage = data.mainImage {
            
            cell.titleLabel.text = data.title
            cell.colorView.backgroundColor = .init(hexString: color)
            cell.sizeLabel.text = data.size
            cell.priceLabel.text = "\(data.price)"
            let url = URL(string: mainImage)
            cell.productImageView?.kf.setImage(with: url)
            cell.currentQuantity = Int(data.quantity)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextController = segue.destination as? CheckViewController
        else { return }
        
        nextController.shoppingCartList = storageManager.shoppingCartList as? [ShoppingCart]
    }

}
