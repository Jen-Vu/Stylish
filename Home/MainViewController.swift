//
//  MainViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/10.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Kingfisher
import ESPullToRefresh

class MainViewController: UIViewController, MarketManagerDelegate {
    
    var productData = [HotProductData]()
    let marketManager = MarketManager()
    let tableViewHeaderHeight: CGFloat = 67
    let tableViewHeightForRow: CGFloat = 258
    let oneImageCellIdentifier = "oneImageCell"
    let fourImageCellIdentifier = "fourImageCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    private class Pony {
        public var popony = 0
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        marketManager.delegate = self
        marketManager.getMarketingHots()
        
        tableView.es.addPullToRefresh { [unowned self] in
            self.marketManager.getMarketingHots()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //tabBarController?.tabBar.isHidden = false
    }
    
    func manager(_ manager: MarketManager, didGet marketingHots: [HotProductData]) {
        productData = marketingHots
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.es.stopPullToRefresh()
        }
    }
    
    func manager(_ manager: MarketManager, didFailWith error: Error) {
        print(error)
    }

}

extension MainViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productData.isEmpty ? 1 : productData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productData.isEmpty ? Int(UIScreen.main.bounds.height / tableViewHeightForRow) : productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: oneImageCellIdentifier,
                    for: indexPath) as? OneImageTableViewCell
                else {
                    return UITableViewCell()
            }
            
            guard !productData.isEmpty else { return cell }
            let url = URL(string: self.productData[indexPath.section].products[indexPath.row].mainImage)
            cell.productImageView.kf.setImage(with: url)
            cell.mainLabel.text = self.productData[indexPath.section].products[indexPath.row].title
            cell.descLabel.text = self.productData[indexPath.section].products[indexPath.row].description
            
            return cell
        } else {
            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: fourImageCellIdentifier,
                    for: indexPath) as? FourImagesTableViewCell
                else {
                    return UITableViewCell()
            }
            
            guard !productData.isEmpty else { return cell }
            var index = 0
            for image in cell.productImages {
                let url = URL(string: self.productData[indexPath.section].products[indexPath.row].images[index])
                image.kf.setImage(with: url)
                
                //確保data出中的照片數少於imageview的數量時不會有問題
                if index + 1 < self.productData[indexPath.section].products[indexPath.row].images.count {
                    index += 1
                }
            }
            cell.mainLabel.text = self.productData[indexPath.section].products[indexPath.row].title
            cell.descLabel.text = self.productData[indexPath.section].products[indexPath.row].description
    
            return cell
        }
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableViewHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(
            frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: tableViewHeaderHeight)
        )
        returnedView.backgroundColor = .white
        
        let label: UILabel = {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            label.textColor = UIColor.greyStylish
            return label
        }()
        
        label.text = productData.isEmpty ? label.text : productData[section].title
        
        returnedView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: returnedView.bottomAnchor, constant: -12),
            label.leadingAnchor.constraint(equalTo: returnedView.leadingAnchor, constant: 16)
            ])
        
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewHeightForRow
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.init(hexString: "EEEEEE")
            UIView.animate(withDuration: 0.75) {
                cell.contentView.backgroundColor = .white
                cell.isSelected = false
            }
            
            if !productData.isEmpty,
                let viewController = storyboard?.instantiateViewController(withIdentifier: "ProductDetailVC")
                as? ProductDetailViewController {
                viewController.product = productData[indexPath.section].products[indexPath.row]
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
}

