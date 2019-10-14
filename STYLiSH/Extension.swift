//
//  Extension.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/13.
//  Copyright © 2019 littema. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addChild(childController: UIViewController, to view: UIView) {
        self.addChild(childController)
        childController.view.frame = view.bounds
        view.addSubview(childController.view)
        childController.didMove(toParent: self)
    }
    
}

extension UIColor {
    
    static var tintStylish: UIColor {
        return UIColor(red: 48/255, green: 44/255, blue: 44/255, alpha: 1.0)
    }
    
    static var greyStylish: UIColor {
        return UIColor(red: 63 / 255.0, green: 58 / 255.0, blue: 58 / 255.0, alpha: 1.0)
    }
    
    static var lightGreyStylish: UIColor {
        return UIColor(red: 100 / 255.0, green: 100 / 255.0, blue: 100 / 255.0, alpha: 1.0)
    }
    
    static var unselectGreyStylish: UIColor {
        return UIColor(red: 136 / 255.0, green: 136 / 255.0, blue: 136 / 255.0, alpha: 1.0)
    }
    
    static var saleRedStylish: UIColor {
        return UIColor(red: 208 / 255.0, green: 2 / 255.0, blue: 27 / 255.0, alpha: 1.0)
    }
    
    static var separateLineStylish: UIColor {
        return UIColor(red: 193 / 255.0, green: 193 / 255.0, blue: 193 / 255.0, alpha: 1.0)
    }
    
    static var shoppingCartCellavailable: UIColor {
        return UIColor(red: 240 / 255.0, green: 240 / 255.0, blue: 240 / 255.0, alpha: 1)
    }
    
    static var shoppingCartCellUnavailable: UIColor {
        return UIColor(red: 240 / 255.0, green: 240 / 255.0, blue: 240 / 255.0, alpha: 0.4)
    }
    
    static var shoppingCartButtonUnavailable: UIColor {
        return UIColor(red: 153 / 255.0, green: 153 / 255.0, blue: 153 / 255.0, alpha: 1)
    }
    
    static var tabBarTint: UIColor {
        return UIColor(red: 119 / 255.0, green: 69 / 255.0, blue: 31 / 255.0, alpha: 1)
    }
    
    static func greyStylishTransparent(for alpha: CGFloat) -> UIColor {
        return UIColor(red: 63 / 255.0, green: 58 / 255.0, blue: 58 / 255.0, alpha: alpha)
    }
    
    static func blackTransparent(for alpha: CGFloat) -> UIColor {
        return UIColor(red: 0 / 255.0, green: 0 / 255.0, blue: 0 / 255.0, alpha: alpha)
    }

}

extension UIColor {
    convenience init(hexString: String) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let intRed = Int(color >> 16) & mask
        let intGreen = Int(color >> 8) & mask
        let intBlue = Int(color) & mask
        let red   = CGFloat(intRed) / 255.0
        let green = CGFloat(intGreen) / 255.0
        let blue  = CGFloat(intBlue) / 255.0
        
        var all = Int(color >> 24) & mask
        if hexString.count <= 8 {
            all = 255
        }
        let alpha = CGFloat(all) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIImage {
    
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)

        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

protocol Convertable: Codable {
    
}

extension Convertable {
    
    func convertToDict() -> [String: String]? {
        
        var dict: [String: String]?
        
        do {
            let encoder = JSONEncoder()
            
            let data = try encoder.encode(self)
            
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String]
            
        } catch {
            print(error)
        }
        
        return dict
    }
}

//swiftlint:disable identifier_name
enum MoneyDisplay {
    case zh_TW
}
//swiftlint:enable identifier_name

extension Int {
    
    func transNTMoneyStyle(locale: MoneyDisplay) -> String {
        switch locale {
        case .zh_TW:
            return "NT$\(self)"
        }
    }
    
}
