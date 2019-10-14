//
//  ProductListCollectionViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/16.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ProductListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
