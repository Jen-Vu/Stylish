//
//  ProfileViewController.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/12.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Layout text
    static var layoutString = [
        ProfileLayoutString(sectionName: NSLocalizedString("MyOrders", comment: ""), button: [
            ProfileButton(name: NSLocalizedString("WaitPayment", comment: ""), image: "Icons_24px_AwaitingPayment"),
            ProfileButton(name: NSLocalizedString("WaitShipment", comment: ""), image: "Icons_24px_AwaitingShipment"),
            ProfileButton(name: NSLocalizedString("WaitReceived", comment: ""), image: "Icons_24px_Shipped"),
            ProfileButton(name: NSLocalizedString("WaitEvaluation", comment: ""), image: "Icons_24px_AwaitingReview"),
            ProfileButton(name: NSLocalizedString("Returns/Refunds", comment: ""), image: "Icons_24px_Exchange")
            ]),
        ProfileLayoutString(sectionName: NSLocalizedString("MoreService", comment: ""), button: [
            ProfileButton(name: NSLocalizedString("Collection", comment: ""), image: "Icons_24px_Starred"),
            ProfileButton(name: NSLocalizedString("Notification", comment: ""), image: "Icons_24px_Notification"),
            ProfileButton(name: NSLocalizedString("Refund", comment: ""), image: "Icons_24px_Refunded"),
            ProfileButton(name: NSLocalizedString("Address", comment: ""), image: "Icons_24px_Address"),
            ProfileButton(name: NSLocalizedString("CustomerService", comment: ""), image: "Icons_24px_CustomerService"),
            ProfileButton(name: NSLocalizedString("FeedBack", comment: ""), image: "Icons_24px_SystemFeedback"),
            ProfileButton(name: NSLocalizedString("Binding", comment: ""), image: "Icons_24px_RegisterCellphone"),
            ProfileButton(name: NSLocalizedString("Settting", comment: ""), image: "Icons_24px_Settings")
            ])
    ]
    
    var profileFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        // 11 / 344 -> width = 60/11, total: 60/11 * 5 + 11 * 4
        let spacing = (UIScreen.main.bounds.size.width - 32) * (11 / 344)
        let width = ((UIScreen.main.bounds.size.width - 32) - spacing * 4) / 5
        
        layout.itemSize = CGSize(width: Int(width), height: 51)
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.size.width, height: 72)
        
        return layout
    }()

    // Identifier
    let cellIdentifier = "CollectionViewCell"
    let myOrderHeaderIdentifier = "myOrderHeaderCell"
    let moreServiceHeaderIdentifier = "moreServiceHeaderCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userPhotoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLayout()
    }
    
    func initLayout() {
        userPhotoImageView.layer.cornerRadius = userPhotoImageView.frame.height / 2.0
        userPhotoImageView.clipsToBounds = true
        
        collectionView.collectionViewLayout = profileFlowLayout
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.register(
            MyOrderCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: myOrderHeaderIdentifier)
        self.collectionView.register(
            MoreServiceCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: moreServiceHeaderIdentifier)
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ProfileViewController.layoutString.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileViewController.layoutString[section].button.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: view.frame.size.width, height: profileFlowLayout.headerReferenceSize.height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader,
            indexPath.section == 0 {
            guard
                let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: myOrderHeaderIdentifier,
                    for: indexPath)
                as? MyOrderCollectionHeaderView
                else {
                    return UICollectionReusableView()
                }
            headerView.sectionLabel.text = ProfileViewController.layoutString[indexPath.section].sectionName
            return headerView
        } else {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: moreServiceHeaderIdentifier,
                for: indexPath)
                as? MoreServiceCollectionHeaderView
                else {
                    return UICollectionReusableView()
                }
            headerView.sectionLabel.text = ProfileViewController.layoutString[indexPath.section].sectionName
            return headerView
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? CollectionViewCell else { return UICollectionViewCell() }
        if indexPath.section == 0 {
            cell.image.image = UIImage(
                named: ProfileViewController.layoutString[indexPath.section].button[indexPath.row].image)
            cell.label.text = ProfileViewController.layoutString[indexPath.section].button[indexPath.row].name
            return cell
        } else {
            cell.image.image = UIImage(
                named: ProfileViewController.layoutString[indexPath.section].button[indexPath.row].image)
            cell.label.text = ProfileViewController.layoutString[indexPath.section].button[indexPath.row].name
            return cell
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0 {
            // 11 / 344 -> width = 60/11, total: 60/11 * 5 + 11 * 4
            return (self.view.frame.size.width - 32) * (11 / 344)
        } else {
            // 11 / 342 -> width = 60/11, total: 60/34 * 4 + 34 * 3
            return (self.view.frame.size.width - 32) * (34 / 342)
        }
    }
}
