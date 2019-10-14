//
//  ProductCollectionViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Kingfisher
import ESPullToRefresh

class CatalogCollectionViewController: UICollectionViewController {
    
    var productManager = ProductManager()
    var productList = [Product]()
    var gridFlowLayout = GridCollectionViewFlowLayout()
    var listFlowLayout = ListCollectionViewFlowLayout()
    var productType: ProductTpye!
    var nextPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCollectionView()
        
        productManager.dataPassHelper.handler = { productListResultsData in

            if productListResultsData.data.isEmpty {
                self.productList = productListResultsData.data
            } else {
                self.productList += productListResultsData.data
            }

            self.nextPage = productListResultsData.paging != nil ? "\(productListResultsData.paging!)" : nil

            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.es.stopPullToRefresh()
            }
        }
        productManager.getProductList(paging: nil, product: self.productType)

        collectionView.es.addPullToRefresh {
            [unowned self] in

            self.productList = [Product]()
            self.productManager.getProductList(paging: nil, product: self.productType)
        }

        collectionView.es.addInfiniteScrolling {
            [unowned self] in
            if let nextPage = self.nextPage {
                self.productManager.getProductList(paging: nextPage, product: self.productType)
                self.collectionView.es.stopLoadingMore()
            } else {
                self.collectionView.es.noticeNoMoreData()
            }
        }
    }

    func initCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = listFlowLayout

        collectionView.register(
            ProductGridCollectionViewCell.nib,
            forCellWithReuseIdentifier: ProductGridCollectionViewCell.identifier)
        collectionView.register(
            ProductListCollectionViewCell.nib,
            forCellWithReuseIdentifier: ProductListCollectionViewCell.identifier)
    }

    func layoutSwitch(sender: UIBarButtonItem) {
        self.collectionView.collectionViewLayout.invalidateLayout()
        if collectionView.collectionViewLayout == listFlowLayout {
            //設定的 icon  要與 layout 相反
            sender.image = UIImage(named: "Icons_24px_ListView")
            collectionView.setCollectionViewLayout(gridFlowLayout, animated: true, completion: { (done) in
                if done {
                    self.collectionView.reloadData()
                }
            })
        } else {
            sender.image = UIImage(named: "Icons_24px_CollectionView")
            collectionView.setCollectionViewLayout(listFlowLayout, animated: true, completion: { (done) in
                if done {
                    self.collectionView.reloadData()
                }
            })
        }
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.collectionView.scrollToItem(at: indexPath, at:.top, animated: true)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return productList.isEmpty ? Int(UIScreen.main.bounds.height / 110) : productList.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        iOS 原生做法，但像是不同改使用 extension 實作
//        let formatter = NumberFormatter()
//        formatter.locale = Locale(identifier: "zh_TW")
//        formatter.numberStyle = .currencyISOCode
//        formatter.maximumFractionDigits = 0
        if collectionView.collectionViewLayout == listFlowLayout {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductListCollectionViewCell.identifier,
                for: indexPath
            ) as? ProductListCollectionViewCell
            else {
                return UICollectionViewCell()
            }

            guard !productList.isEmpty else { return cell }
            cell.titleLabel.text = productList[indexPath.row].title
            cell.priceLabel.text = productList[indexPath.row].price.transNTMoneyStyle(locale: .zh_TW)
            let url = URL(string: productList[indexPath.row].mainImage)
            cell.image.kf.setImage(with: url)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductGridCollectionViewCell.identifier,
                for: indexPath
                ) as? ProductGridCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            
            cell.imageWidth.constant = gridFlowLayout.itemSize.width
            
            guard !productList.isEmpty else { return cell }
            cell.titleLabel.text = productList[indexPath.row].title
            cell.priceLabel.text = productList[indexPath.row].price.transNTMoneyStyle(locale: .zh_TW)
            let url = URL(string: productList[indexPath.row].mainImage)
            cell.image.kf.setImage(with: url)
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var nextPageImage: UIImage?
//        
//        if collectionView.collectionViewLayout == listFlowLayout {
//            let selectedCell = collectionView.cellForItem(at: indexPath) as! ProductListCollectionViewCell
//            nextPageImage = selectedCell.image.image
//        } else {
//            let selectedCell = collectionView.cellForItem(at: indexPath) as! ProductGridCollectionViewCell
//            nextPageImage = selectedCell.image.image
//        }
        
        if !productList.isEmpty,
            let controller = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC"
            ) as? ProductDetailViewController {
            
            controller.product = productList[indexPath.row]
            //controller.productImageView.image = image
            
            //Tip: 建議使用右向左滑出建議用 Push，下至上建議使用 Present
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
}
