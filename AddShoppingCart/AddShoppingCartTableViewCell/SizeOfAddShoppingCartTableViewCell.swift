//
//  SizeShoppingCartTableViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/23.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class SizeOfAddShoppingCartTableViewCell: UITableViewCell {
    
    var item: AddShoppingCartItem? {
        didSet {
            guard let item = item as? SizeShoppingCartItem else { return }
            viewModel = item.viewModel
            sizes = item.sizes
            initButtonStatus()
        }
    }
    var viewModel: AddShoppingCartViewModel? {
        didSet {
            viewModel?.helper.passColor = { selectColor in
                self.selectColor = selectColor
                self.checkSizeStock(select: selectColor.code)
            }
        }
    }
    var sizes = [String]()
    var stockStatus = [StockStatus]()
    var sizeChoices = [Bool]()
    var selectColor: (name: String, code: String)? {
        didSet {
            initButtonStatus()
            viewModel?.helper.passMaxQuantity?(nil)
        }
    }

    var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 48, height: 48)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        return layout
    }()
    
    @IBOutlet weak var sizeCollectionView: UICollectionView! {
        didSet {
            sizeCollectionView.isScrollEnabled = false
            sizeCollectionView.collectionViewLayout = flowLayout
            sizeCollectionView.dataSource = self
            sizeCollectionView.delegate = self
            sizeCollectionView.register(SizeShoppingCartCollectionViewCell.self, forCellWithReuseIdentifier: "SizeCell")
        }
    }
    @IBOutlet weak var sizeCollectionVewHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.text = NSLocalizedString("ChoiceSize", comment: "")
        nameLabel.textColor = .lightGreyStylish
        nameLabel.font = .systemFont(ofSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func initButtonStatus() {
        stockStatus = [StockStatus]()
        sizeChoices = [Bool]()
        for _ in sizes {
            sizeChoices.append(false)
            stockStatus.append(.none)
        }
    }
    
    func checkSizeStock(select colorCode: String) {
        guard let viewModel = viewModel else { return }
        stockStatus = [StockStatus]()
        for size in sizes {
            stockStatus.append(viewModel.checkStockFor(colorCode: colorCode, size: size))
        }
        sizeCollectionView.reloadData()
    }
    
    func upadteSelect(index: Int) {
        sizeChoices = [Bool]()
        for _ in sizes {
            sizeChoices.append(false)
        }
        sizeChoices[index] = true
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension SizeOfAddShoppingCartTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = sizeCollectionView.dequeueReusableCell(
            withReuseIdentifier: "SizeCell",
            for: indexPath) as? SizeShoppingCartCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        switch stockStatus[indexPath.row] {
        case .available:
            cell.backgroundColor = .shoppingCartCellavailable
            cell.view.image = nil
            cell.label.textColor = .greyStylish
        case .unavailable:
            cell.backgroundColor = .shoppingCartCellUnavailable
            cell.view.image = UIImage.asset(.Image_StrikeThrough)
            cell.label.textColor = UIColor.greyStylishTransparent(for: 0.4)
        case .none:
            cell.backgroundColor = .shoppingCartCellUnavailable
            cell.view.image = nil
            cell.label.textColor = UIColor.greyStylishTransparent(for: 0.4)
        }
        
        if sizeChoices[indexPath.row] {
            cell.layer.borderColor = UIColor.greyStylish.cgColor
            cell.layer.borderWidth = 1.0
        } else {
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 1.0
        }
        
        cell.label.text = sizes[indexPath.row]
        return cell
    }
}

extension SizeOfAddShoppingCartTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let viewModel = viewModel,
            let selectColor = self.selectColor,
            viewModel.checkStockFor(colorCode: selectColor.code, size: sizes[indexPath.row]) == .available
        else { return }
        
        upadteSelect(index: indexPath.row)

        var index = 0
        for choice in sizeChoices {
            if choice {
                //let stock = viewModel.getStockFor(colorCode: selectColorCode, size: sizes[indexPath.row])
                viewModel.selectSize = sizes[index]
                //viewModel.helper.passMaxQuantity?(stock)
            }
            index += 1
        }
        
        collectionView.reloadData()
    }
}

class SizeShoppingCartCollectionViewCell: UICollectionViewCell {
    
    var view = UIImageView()
    var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .lightGreyStylish
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        view = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        view.backgroundColor = .shoppingCartCellUnavailable
        self.addSubview(view)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: label.trailingAnchor),
            label.heightAnchor.constraint(equalToConstant: 24)
        ])

    }
    
}
