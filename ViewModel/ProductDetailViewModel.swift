//
//  ViewModel.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/20.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

enum ProductDetailItemType {
    case title
    case description
    case color
    case sizes
    case variants
    case texture
    case wash
    case place
    case note
}

protocol ProductDetailItem {
    var type: ProductDetailItemType { get }
    var rowCount: Int { get }
}

class ProductDetailViewModel: NSObject {
    
    var items = [ProductDetailItem]()
    var product: Product!
    
    init(product: Product) {
        super.init()
        self.product = product
        
        let productDetailTitleItem = ProductDetailTitleItem(
            title: product.title,
            price: product.price.transNTMoneyStyle(locale: .zh_TW),
            id: "\(product.id)")
        items.append(productDetailTitleItem)
        
        let productDetailDescriptionItem = ProductDetailDescriptionItem(description: product.description)
        items.append(productDetailDescriptionItem)
        
        let productDetailColorsItem = ProductDetailColorsItem(colors: product.colors)
        items.append(productDetailColorsItem)
        
        let productDetailSizesItem = ProductDetailSizesItem(sizes: product.sizes)
        items.append(productDetailSizesItem)

        let productDetailVariantsItem = ProductDetailVariantsItem(variants: product.variants)
        items.append(productDetailVariantsItem)
        
        let productDetailTextureItem = ProductDetailTextureItem(text: product.texture)
        items.append(productDetailTextureItem)
        
        let productDetailWashItem = ProductDetailWashItem(text: product.wash)
        items.append(productDetailWashItem)
        
        let productDetailPlaceItem = ProductDetailPlaceItem(text: product.place)
        items.append(productDetailPlaceItem)
        
        let productDetailNoteItem = ProductDetailNoteItem(text: product.note)
        items.append(productDetailNoteItem)
        
    }
    
}

extension ProductDetailViewModel: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //swiftlint:disable cyclomatic_complexity function_body_length
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .title:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: TitleOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? TitleOfProductDetailTableViewCell {
                cell.item = item
                return cell
            }
        case .description:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: DescriptionOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? DescriptionOfProductDetailTableViewCell {
                cell.item = item
                return cell
            }
        case .color:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: ColorOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? ColorOfProductDetailTableViewCell {
                cell.item = item
                return cell
            }
        case .sizes:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: StringOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? StringOfProductDetailTableViewCell {
                cell.itemSizes = item
                return cell
            }
        case .variants:
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: StringOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? StringOfProductDetailTableViewCell {
                cell.itemVariants = item
                return cell
            }
        case .texture:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StringOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? StringOfProductDetailTableViewCell {
                cell.itemTexture = item
                return cell
            }
        case .wash:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StringOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? StringOfProductDetailTableViewCell {
                cell.itemWash = item
                return cell
            }
        case .place:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StringOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? StringOfProductDetailTableViewCell {
                cell.itemPlace = item
                return cell
            }
        case .note:
            if let cell = tableView.dequeueReusableCell(withIdentifier: StringOfProductDetailTableViewCell.identifier,
                for: indexPath
            ) as? StringOfProductDetailTableViewCell {
                cell.itemNote = item
                return cell
            }
        }
        return UITableViewCell()
    }
    //swiftlint:enable cyclomatic_complexity
}

class ProductDetailTitleItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .title
    }
    
    var rowCount: Int {
        return 1
    }

    var title: String
    
    var price: String
    
    var id: String
    
    init(title: String, price: String, id: String) {
        self.title = title
        self.price  = price
        self.id = id
    }
    
}

class ProductDetailDescriptionItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .description
    }
    
    var rowCount: Int {
        return 1
    }
    
    var description: String
    
    init(description: String) {
        self.description = description
    }
    
}

class ProductDetailColorsItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .color
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name = NSLocalizedString("Color", comment: "")
    var colors: [Color]
    var colorsCount: Int

    init(colors: [Color]) {
        self.colorsCount = colors.count
        self.colors = colors
    }
    
}

class ProductDetailSizesItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .sizes
    }
    
    var name = NSLocalizedString("Size", comment: "")
    var rowCount: Int {
        return 1
    }
    
    var sizesString: String
    
    init(sizes: [String]) {
        self.sizesString = sizes.joined(separator: " - ")
    }
    
}

class ProductDetailVariantsItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .variants
    }
    
    var name = NSLocalizedString("Stock", comment: "")
    var rowCount: Int {
        return 1
    }
    
    var totalStock: String
    
    init(variants: [Variant]) {
        var count = 0
        for variant in variants {
            count += variant.stock
        }
        self.totalStock = "\(count)"
    }
    
}

class ProductDetailTextureItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .texture
    }
    
    var name = NSLocalizedString("Texture", comment: "")

    var rowCount: Int {
        return 1
    }
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
}

class ProductDetailWashItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .wash
    }
    
    var name = NSLocalizedString("Wash", comment: "")
    
    var rowCount: Int {
        return 1
    }
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
}

class ProductDetailPlaceItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .place
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name = NSLocalizedString("MadeIn", comment: "")
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
}

class ProductDetailNoteItem: ProductDetailItem {
    
    var type: ProductDetailItemType {
        return .note
    }
    
    var rowCount: Int {
        return 1
    }
    
    var name = NSLocalizedString("Note", comment: "")
    
    var text: String
    
    init(text: String) {
        self.text = text
    }
    
}
