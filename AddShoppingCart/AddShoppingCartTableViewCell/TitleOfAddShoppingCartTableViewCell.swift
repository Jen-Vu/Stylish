//
//  TitleShoppingCartTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class TitleOfAddShoppingCartTableViewCell: UITableViewCell {
    
    var item: AddShoppingCartItem? {
        didSet {
            guard let item = item as? TitleShoppingCartItem else { return }
            viewModel = item.viewModel
            titleLabel.text = item.title
            priceLabel.text = item.price
        }
    }
    var viewModel: AddShoppingCartViewModel?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var separateLine: UIView!
    
    @IBAction func closeButton(_ sender: UIButton) {
        guard let viewController = viewModel?.viewController as? AddShoppingCartViewController else { return }
        viewController.disMissShoppingCart()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.textColor = .greyStylish
        priceLabel.textColor = .greyStylish
        titleLabel.text = "讀取中..."
        priceLabel.text = "讀取中..."
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
