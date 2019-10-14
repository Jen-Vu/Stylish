//
//  ShoppingCart.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/23.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

enum AddShoppingCartItemType {
    case title
    case color
    case size
    case quantity
}

protocol AddShoppingCartItem {
    var type: AddShoppingCartItemType { get }
}

struct Helper {
    var passColor: ( ( (name: String, code: String) ) -> Void )?
    var passMaxQuantity: ((Int?) -> Void)?
}

class AddShoppingCartViewModel: NSObject {
    
    var viewController: UIViewController?
    var items = [AddShoppingCartItem]()
    var product: Product!
    var helper = Helper()
    var selectColor: (name: String, code: String)? {
        didSet {
            guard let selectColor = selectColor else { return }
            helper.passColor?(selectColor)
        }
    }
    var selectSize: String? {
        didSet {
            guard let selectColor = selectColor, let selectSize = selectSize else { return }
            let stock = getStockFor(colorCode: selectColor.code, size: selectSize)
            helper.passMaxQuantity?(stock)
        }
    }
    var selectQuantity: String?
    
    init(product: Product, viewController: UIViewController) {
        super.init()
        self.product = product
        self.viewController = viewController
        
        let titleShoppingCartItem = TitleShoppingCartItem(
                viewModel: self,
                title: product.title,
                price: product.price.transNTMoneyStyle(locale: .zh_TW))
        items.append(titleShoppingCartItem)
        
        let colorShoppingCartItem = ColorShoppingCartItem(
                viewModel: self,
                colors: product.colors)
        items.append(colorShoppingCartItem)
        
        let sizeShoppingCartItem = SizeShoppingCartItem(
            viewModel: self,
            sizes: product.sizes,
            variants: product.variants)
        items.append(sizeShoppingCartItem)
        
        let quantityShoppingCartItem = QuantityShoppingCartItem(
                viewModel: self,
                variants: product.variants)
        items.append(quantityShoppingCartItem)
        
    }

}

extension AddShoppingCartViewModel {
    func getStockFor(colorCode: String, size: String) -> Int {

        for variant in product.variants where colorCode == variant.colorCode && size == variant.size {
            return variant.stock
        }
        return 0
    }
    
    func checkStockFor(colorCode: String, size: String) -> StockStatus {
        if getStockFor(colorCode: colorCode, size: size) > 0 {
            return .available
        } else {
            return .unavailable
        }
    }
    
    func getOrderContent() -> OrderProduct? {
        guard let selectColor = selectColor,
            let selectSize = selectSize,
            let selectQuantity = selectQuantity
        else { return nil }
        
        let orderProduct = OrderProduct(
            id: "\(product.id)",
            title: product.title,
            price: "\(product.price)",
            colorName: selectColor.name,
            colorCode: selectColor.code,
            size: selectSize,
            quantity: selectQuantity,
            mainImage: product.mainImage)
        
        return orderProduct
    }
}

extension AddShoppingCartViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .title:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleOfAddShoppingCartTableViewCell.identifier,
                for: indexPath) as? TitleOfAddShoppingCartTableViewCell {
                cell.item = item
                return cell
            }
        case .color:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: ColorOfAddShoppingCartTableViewCell.identifier,
                for: indexPath) as? ColorOfAddShoppingCartTableViewCell {
                cell.item = item
                return cell
            }
        case .size:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: SizeOfAddShoppingCartTableViewCell.identifier,
                for: indexPath) as? SizeOfAddShoppingCartTableViewCell {
                cell.item = item
                return cell
            }
        case .quantity:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: QuantityOfAddShoppingCartTableViewCell.identifier,
                for: indexPath) as? QuantityOfAddShoppingCartTableViewCell {
                cell.item = item
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

class TitleShoppingCartItem: AddShoppingCartItem {
    
    var type: AddShoppingCartItemType { return .title }
    var viewModel: AddShoppingCartViewModel
    var title: String
    var price: String
    
    init(viewModel: AddShoppingCartViewModel, title: String, price: String) {
        self.viewModel = viewModel
        self.title = title
        self.price = price
    }
    
}

class ColorShoppingCartItem: AddShoppingCartItem {
    
    var type: AddShoppingCartItemType { return .color }
    var viewModel: AddShoppingCartViewModel
    var colors: [Color]
    
    init(viewModel: AddShoppingCartViewModel, colors: [Color]) {
        self.viewModel = viewModel
        self.colors = colors
    }
    
}

class SizeShoppingCartItem: AddShoppingCartItem {
    
    var type: AddShoppingCartItemType { return .size }
    var viewModel: AddShoppingCartViewModel
    var sizes: [String]
    var variants: [Variant]
    
    init(viewModel: AddShoppingCartViewModel, sizes: [String], variants: [Variant]) {
        self.viewModel = viewModel
        self.sizes = sizes
        self.variants = variants
    }
    
}

class QuantityShoppingCartItem: AddShoppingCartItem {
    
    var type: AddShoppingCartItemType { return .quantity }
    var viewModel: AddShoppingCartViewModel
    
    init(viewModel: AddShoppingCartViewModel, variants: [Variant]) {
        self.viewModel = viewModel
    }
    
}
