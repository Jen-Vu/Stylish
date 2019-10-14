//
//  ColorShoppingCartTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ColorOfAddShoppingCartTableViewCell: UITableViewCell {
    
    var item: AddShoppingCartItem? {
        didSet {
            guard let item = item as? ColorShoppingCartItem else { return }
            colors = item.colors
            viewModel = item.viewModel
            for _ in colors {
                colorChoices.append(false)
            }
        }
    }
    var viewModel: AddShoppingCartViewModel?
    var colors = [Color]()
    var colorChoices = [Bool]()
    var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        return layout
    }()
    
    @IBOutlet weak var colorCollectionView: UICollectionView! {
        didSet {
            colorCollectionView.isScrollEnabled = false
            colorCollectionView.collectionViewLayout = flowLayout
            colorCollectionView.dataSource = self
            colorCollectionView.delegate = self
            colorCollectionView.register(
                ColorShoppingCartCollectionViewCell.self,
                forCellWithReuseIdentifier: "ColorCell")
        }
    }
    @IBOutlet weak var colorCollectionViewHight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = NSLocalizedString("ChoiceColor", comment: "")
        nameLabel.textColor = .lightGreyStylish
        nameLabel.font = .systemFont(ofSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func updataCurrentSelect(_ selectIndex: Int) {
        for index in colorChoices.indices {
            colorChoices[index] = false
        }
        colorChoices[selectIndex] = true
    }
    
}

extension ColorOfAddShoppingCartTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ColorCell", for: indexPath
        ) as? ColorShoppingCartCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        if colorChoices[indexPath.row] {
            cell.layer.borderColor = UIColor.greyStylish.cgColor
            cell.layer.borderWidth = 1.0
        } else {
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 1.0
        }
        
        cell.view.backgroundColor = UIColor.init(hexString: colors[indexPath.row].code)
        return cell
    }
    
}

extension ColorOfAddShoppingCartTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        updataCurrentSelect(indexPath.row)
        
        var index = 0
        for choice in colorChoices {
            if choice {
                viewModel?.selectColor = (colors[index].name, colors[index].code)
            }
            index += 1
        }
        collectionView.reloadData()
    }
}

class ColorShoppingCartCollectionViewCell: UICollectionViewCell {
    
    var view = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(view)
    }
    
}
