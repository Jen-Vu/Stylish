//
//  StringProductDetailTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/19.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ColorOfProductDetailTableViewCell: UITableViewCell {
    
    var item: ProductDetailItem? {
        didSet {
            guard let item = item as? ProductDetailColorsItem else {
                return
            }
            
            nameLabel.text = item.name
            createColorBlock(cell: self, colors: item.colors)
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorContainerView: UIView!
    @IBOutlet weak var colorContainerHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .lightGreyStylish

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func createColorBlock(cell: ColorOfProductDetailTableViewCell, colors: [Color]) {
        var currentX = 0
        var currentY = 0
        
        for color in colors {
            let view = UIView()
            
            view.backgroundColor = UIColor.init(hexString: color.code)
            view.frame = CGRect(x: currentX, y: currentY, width: 24, height: 24)
            view.layer.borderColor = UIColor.unselectGreyStylish.cgColor
            view.layer.borderWidth = 1
            
            cell.colorContainerView.addSubview(view)
            
            if currentX > Int(cell.colorContainerView.frame.width) {
                currentX = 0
                currentY += 24 + 8
            } else {
                currentX += 24 + 8
            }
        }
        
        cell.colorContainerHeight.constant = CGFloat(currentY + 24)
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
