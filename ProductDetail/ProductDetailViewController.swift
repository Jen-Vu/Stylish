//
//  ProductDetailViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/19.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit
import Kingfisher

class ProductDetailViewController: UIViewController {
    
    var viewModel: ProductDetailViewModel?
    var product: Product? {
        didSet {
            //Tip: 資料收到後的事，應該一起處理
            viewModel = ProductDetailViewModel(product: product!)
            if productTabelView != nil {
                productTabelView.dataSource = viewModel
            }
            productPhtotoPageControl.numberOfPages = product!.images.count
        }
    }
    var productScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    var productStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.axis = .horizontal
        return stackView
    }()
    var productPhtotoPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    var productHeightConstraint: NSLayoutConstraint?
    var containerView = UIView()
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addShoppingCartButton: UIButton!
    
    @IBOutlet weak var productTabelView: UITableView! {
        didSet {
            productTabelView.delegate = self
            productTabelView.register(
                TitleOfProductDetailTableViewCell.nib,
                forCellReuseIdentifier: TitleOfProductDetailTableViewCell.identifier)
            productTabelView.register(
                DescriptionOfProductDetailTableViewCell.nib,
                forCellReuseIdentifier: DescriptionOfProductDetailTableViewCell.identifier)
            productTabelView.register(
                ColorOfProductDetailTableViewCell.nib,
                forCellReuseIdentifier: ColorOfProductDetailTableViewCell.identifier)
            productTabelView.register(
                StringOfProductDetailTableViewCell.nib,
                forCellReuseIdentifier: StringOfProductDetailTableViewCell.identifier)
            
            if viewModel != nil {
                productTabelView.dataSource = viewModel
            }
        }
    }
    
    @IBAction func addShoppingCart(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "ShoppingCartVC")
            as? AddShoppingCartViewController {
            
            nextVC.modalPresentationStyle = .overCurrentContext
            //nextVC.view.backgroundColor = UIColor.blackTransparent(for: 0.4)
            nextVC.product = self.product
            present(nextVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Tip: 若要讓 tabelView 頂到螢幕頂端，storyboard contentInset 要設為 never
        initProductPhotoLayout()
        
        productScrollView.delegate = self

        view.bringSubviewToFront(productPhtotoPageControl)
        view.bringSubviewToFront(backButton)
        
        //Tip: 若在這建立 viewModel 生命週期只會在這 scoop，因為 tableView delegate 會是 weak 所以 viewDidLoad 跑完就會釋放，會是nil
        //var viewModel = ProductDetailViewModel(product: product!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
//    @objc func pageControllHandler(sender: UIPageControl) {
//        print(sender.currentPage)
//    }
    
    func initProductPhotoLayout() {
        containerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 500))

        productTabelView.tableHeaderView = containerView
        //swiftlint:disable line_length
        productHeightConstraint = NSLayoutConstraint.init(item: productScrollView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 500)
        //swiftlint:enable line_length
        productScrollView.addConstraint(productHeightConstraint!)
        
        containerView.addSubview(productScrollView)
        NSLayoutConstraint.activate([
            productScrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            productScrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            //Tip: 圖片需要往上長，所以要 bottomAnchor
            productScrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        //Tip: Constraint 有主次之分，屬於 Parent 的 Constraint 不可以 add 到 Child 上，同一階層的 Constraint 會紀錄在先產生者的身上
        productScrollView.addSubview(productStackView)
        NSLayoutConstraint.activate([
            productStackView.leftAnchor.constraint(equalTo: productScrollView.leftAnchor),
            productStackView.rightAnchor.constraint(equalTo: productScrollView.rightAnchor),
            productStackView.topAnchor.constraint(equalTo: productScrollView.topAnchor),
            productStackView.bottomAnchor.constraint(equalTo: productScrollView.bottomAnchor),
            productStackView.heightAnchor.constraint(equalTo: productScrollView.heightAnchor)
            ])
        
        if let product = product {
            for image in product.images {
                let imageView = UIImageView()
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.clipsToBounds = true
                imageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
                imageView.contentMode = .scaleAspectFill
                
                let url = URL(string: image)
                imageView.kf.setImage(with: url)
                productStackView.addArrangedSubview(imageView)
            }
            //productPhtotoPageControl.addTarget(self, action: #selector(pageControllHandler), for: .touchUpInside)
        }
        initProductPhotoPageControl()
        
    }
    
    func initProductPhotoPageControl() {
        productPhtotoPageControl.currentPage = 0
        
        productPhtotoPageControl.pageIndicatorTintColor = .greyStylish
        productPhtotoPageControl.currentPageIndicatorTintColor = .white
        productPhtotoPageControl.isUserInteractionEnabled = false
        
        productScrollView.addSubview(productPhtotoPageControl)
        NSLayoutConstraint.activate([
            productPhtotoPageControl.widthAnchor.constraint(equalToConstant: 80),
            productPhtotoPageControl.heightAnchor.constraint(equalToConstant: 20),
            productPhtotoPageControl.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16),
            productPhtotoPageControl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
            ])
        //自定義坑空心圓樣式
//        let image = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: .darkGray)
//        self.productPhtotoPageControl.pageIndicatorTintColor = UIColor.init(patternImage: image!)
//        self.productPhtotoPageControl.currentPageIndicatorTintColor = .white
    }
    
}

extension ProductDetailViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.self == productTabelView, scrollView.contentOffset.y < 0 {
            print(scrollView.contentOffset.y)
            //Tip: 下拉多少圖片就要長高多少
            let yPosition = 500 - scrollView.contentOffset.y
            //Tip: 不可以在這直接 addConstraint，這等於一直增加新的 Constraint 在 View 之上，所以需要建立變數去改變，並要小心 Frame 與 Autolayout 混用
            productHeightConstraint?.isActive = false
            productHeightConstraint = productScrollView.heightAnchor.constraint(equalToConstant: yPosition)
            productHeightConstraint?.isActive = true
            productScrollView.layoutIfNeeded()
    
        } else if scrollView.self == productScrollView {
            let currentIndex = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            productPhtotoPageControl.currentPage = currentIndex
        }
    }
    
}
