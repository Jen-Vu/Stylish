//
//  StringProductDetailTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/19.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class StringOfProductDetailTableViewCell: UITableViewCell {
    
    var itemSizes: ProductDetailItem? {
        didSet {
            guard let item = itemSizes as? ProductDetailSizesItem else { return }
            nameLabel.text = item.name
            infoLabel.text = item.sizesString
        }
    }
    
    var itemVariants: ProductDetailItem? {
        didSet {
            guard let item = itemVariants as? ProductDetailVariantsItem else { return }
            nameLabel.text = item.name
            infoLabel.text = item.totalStock
        }
    }
    
    var itemTexture: ProductDetailItem? {
        didSet {
            guard let item = itemTexture as? ProductDetailTextureItem else { return }
            nameLabel.text = item.name
            infoLabel.text = item.text
        }
    }
    
    var itemWash: ProductDetailItem? {
        didSet {
            guard let item = itemWash as? ProductDetailWashItem else { return }
            nameLabel.text = item.name
            infoLabel.text = item.text
        }
    }
    
    var itemPlace: ProductDetailItem? {
        didSet {
            guard let item = itemPlace as? ProductDetailPlaceItem else { return }
            nameLabel.text = item.name
            infoLabel.text = item.text
        }
    }
    
    var itemNote: ProductDetailItem? {
        didSet {
            guard let item = itemNote as? ProductDetailNoteItem else { return }
            nameLabel.text = item.name
            infoLabel.text = item.text
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.font = .boldSystemFont(ofSize: 16)
        nameLabel.textColor = .lightGreyStylish
        infoLabel.font = .boldSystemFont(ofSize: 16)
        infoLabel.textColor = .greyStylish
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
