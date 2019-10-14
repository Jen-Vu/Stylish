//
//  DescriptionProductDetailTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/20.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class DescriptionOfProductDetailTableViewCell: UITableViewCell {
    
    var product: Product! {
        didSet {
            descriptionLabel.text = product.description
        }
    }
    
    var item: ProductDetailItem? {
        didSet {
            guard let item = item as? ProductDetailDescriptionItem else {
                return
            }
            
            descriptionLabel.text = item.description
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.font = .boldSystemFont(ofSize: 15)
        descriptionLabel.textColor = .lightGreyStylish
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
