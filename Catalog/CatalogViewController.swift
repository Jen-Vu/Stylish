//
//  CatalogViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/14.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class CatalogViewController: UIViewController {
    
    var womenProductVC: CatalogCollectionViewController!
    var menProductVC: CatalogCollectionViewController!
    var accessoriesProductVC: CatalogCollectionViewController!
    var currentProductType: ProductTpye = .women
    
    @IBOutlet var selectionTabButtons: [UIButton]!
    @IBOutlet weak var selectionUnderlineView: UIView!
    @IBOutlet weak var productScrollView: UIScrollView!
    @IBOutlet weak var womenProductView: UIView!
    @IBOutlet weak var menProductView: UIView!
    @IBOutlet weak var accessoriesProductView: UIView!
    @IBOutlet weak var tabWomenButton: UIButton!
    @IBOutlet weak var tabMenButton: UIButton!
    @IBOutlet weak var tabAccessoriesButton: UIButton!
    
    @IBAction func selectionTabs(_ sender: UIButton) {
        updateSelectTab(selectButton: sender.tag)
        
        let pagePointX = CGFloat(sender.tag) * UIScreen.main.bounds.width
        productScrollView.setContentOffset(CGPoint(x: pagePointX, y: 0), animated: true)
    }

    @IBAction func switchLayoutButton(_ sender: UIBarButtonItem) {
        womenProductVC.layoutSwitch(sender: sender)
        menProductVC.layoutSwitch(sender: sender)
        accessoriesProductVC.layoutSwitch(sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        productScrollView.delegate = self
        
        seteupChildViewController()
        updateSelectTab(selectButton: nil)
    }
    
    private func seteupChildViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard
            let womenProductVC = storyboard.instantiateViewController(withIdentifier:
            "ProductCollectionViewController")
                as? CatalogCollectionViewController
        else {
            return
        }
        womenProductVC.productType = .women
        addChild(childController: womenProductVC, to: womenProductView)
        self.womenProductVC = womenProductVC
        
        guard
            let menProductVC = storyboard.instantiateViewController(withIdentifier:
            "ProductCollectionViewController"
            ) as? CatalogCollectionViewController else { return }
        menProductVC.productType = .men
        addChild(childController: menProductVC, to: menProductView)
        self.menProductVC = menProductVC
        
        guard
            let accessoriesProductVC = storyboard.instantiateViewController(
                withIdentifier: "ProductCollectionViewController"
            ) as? CatalogCollectionViewController
        else {
            return
        }
        accessoriesProductVC.productType = .accessories
        addChild(childController: accessoriesProductVC, to: accessoriesProductView)
        self.accessoriesProductVC = accessoriesProductVC

    }
    
    func updateSelectTab(selectButton index: Int?) {

        for btn in selectionTabButtons {
            btn.setTitleColor(UIColor.unselectGreyStylish, for: .normal)
        }
        
        guard let index = index else {
            selectionTabButtons[0].setTitleColor(UIColor.greyStylish, for: .normal)
            return
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.selectionUnderlineView.frame.origin = self.selectionTabButtons[index].frame.origin
        })
        selectionTabButtons[index].setTitleColor(UIColor.greyStylish, for: .normal)
        
        switch index {
        case 0: currentProductType = .women
        case 1: currentProductType = .men
        case 2: currentProductType = .accessories
        default: break
        }
    }

}

extension CatalogViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        updateSelectTab(selectButton: Int(pageIndex))
    }
    
}
