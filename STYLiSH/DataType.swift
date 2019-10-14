//
//  DataType.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/11.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

struct HotResultsData: Codable {
    var data: [HotProductData]
}

struct HotProductData: Codable {
    var title: String
    var products: [Product]
}

struct Product: Codable {
    var id: Int
    var category: String?
    var title: String
    var description: String
    var price: Int
    var texture: String
    var wash: String
    var place: String
    var note: String
    var story: String
    var colors: [Color]
    var sizes: [String]
    var variants: [Variant]
    var mainImage: String
    var images: [String]
    
    enum CodingKeys: String, CodingKey {
        case mainImage = "main_image"
        case id, category, title, description, price, texture, wash, place, note, story, colors, sizes, variants, images
    }
}

struct Color: Codable {
    var name: String
    var code: String
}

struct Variant: Codable {
    var colorCode: String
    var size: String
    var stock: Int
    
    enum CodingKeys: String, CodingKey {
        case colorCode = "color_code"
        case size, stock
    }
}

struct ProductListResultsData: Codable {
    var data: [Product]
    var paging: Int?
}

struct LoginResult: Decodable {
    var data: LoginContentResult?
    var error: FBerror?
}

struct FBerror: Decodable {
    var message: String
    var type: String
    var code: Int
    var fbtraceId: String
    
    enum CodingKeys: String, CodingKey {
        case fbtraceId = "fbtrace_id"
        case message, type, code
    }
}

struct LoginContentResult: Decodable {
    var accessToken: String
    var accessExpired: Int
    var user: LoginContentUserResult
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case accessExpired = "access_expired"
        case user
    }
}

struct LoginContentUserResult: Decodable {
    var id: Int
    var provider: String
    var name: String
    var email: String
    var picture: String
}

struct ProfileLayoutString {
    var sectionName: String
    var button: [ProfileButton]
}

struct ProfileButton {
    var name: String
    var image: String
}

struct OrderProduct: Convertable {
    var id: String
    var title: String
    var price: String
    var colorName: String
    var colorCode: String
    var size: String
    var quantity: String
    var mainImage: String
}

enum DefaultContent: String {
    case image = "Image_Placeholder"
    case string = "讀取中..."
    case none = "-"
}

// swiftlint:disable identifier_name
enum ImageString: String {
    case Image_StrikeThrough
    case Icons_24px_DropDown
}
// swiftlint:enable identifier_name

extension UIImage {
    
    static func asset(_ asset: ImageString) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}

enum StockStatus {
    case available
    case unavailable
    case none
}

struct RecipientInfo: Codable {
    var name: String
    var phone: String
    var email: String
    var address: String
    var time: String
}

struct PaymentInfo {
    var payment: String
    var cardNumber: String
    var dueDate: String
    var verifyCode: String
}

struct OrderCheckOutInfo: Codable {
    var prime: String
    var order: OrderInfo
    
    init(prime: String, orderInfo: OrderInfo) {
        self.prime = prime
        self.order = orderInfo
    }
}

struct OrderInfo: Codable {
    var shipping = "delivery"
    var payment: String
    var subtotal: Int
    var freight: Int
    var total: Int
    var recipient: RecipientInfo
    var list: [ListInfo]
    
    static func transToListInfo(products: [ShoppingCart]) -> [ListInfo] {
        var listInfo = [ListInfo]()
        for product in products {
            guard let title = product.title,
                let colorName = product.colorName,
                let colorCode = product.colorCode,
                let size = product.size
                else { return [ListInfo]() }
            
            let item = ListInfo(
                id: "\(product.id)",
                name: title,
                price: Int(product.price),
                color: ColorInfo(code: colorCode, name: colorName),
                size: size,
                qty: Int(product.quantity))
            
            listInfo.append(item)
        }
        return listInfo
    }
    
    init(
        payment: String,
        subtotal: Int,
        freight: Int,
        total: Int,
        recipient: RecipientInfo,
        orderProducts: [ShoppingCart]) {
        
        self.payment = payment
        self.subtotal = subtotal
        self.freight = freight
        self.total = total
        self.recipient = recipient
        self.list = OrderInfo.transToListInfo(products: orderProducts)
    }
}

struct ListInfo: Codable {
    var id: String
    var name: String
    var price: Int
    var color: ColorInfo
    var size: String
    var qty: Int
}

struct ColorInfo: Codable {
    var code: String
    var name: String
}
