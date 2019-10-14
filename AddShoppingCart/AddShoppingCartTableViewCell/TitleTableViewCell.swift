//
//  TitleTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class TitleShoppingCartTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var separateLine: UIView!
    
    @IBAction func closeButton(_ sender: UIButton) {

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = .greyStylish
        priceLabel.textColor = .greyStylish
        titleLabel.text = "讀取中..."
        titleLabel.text = "讀取中..."
        separateLine.backgroundColor = .separateLineStylish
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
