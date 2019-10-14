//
//  TitleProductDetailTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/20.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class TitleOfProductDetailTableViewCell: UITableViewCell {
    
    var item: ProductDetailItem? {
        didSet {
            guard let item = item as? ProductDetailTitleItem else {
                return
            }
            
            titleLabel.text = item.title
            priceLabel.text = item.price
            idLabel.text = item.id
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .greyStylish

        priceLabel.font = .boldSystemFont(ofSize: 18)
        priceLabel.textColor = .greyStylish
        
        idLabel.font = .boldSystemFont(ofSize: 14)
        idLabel.textColor = .unselectGreyStylish

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
