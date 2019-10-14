//
//  ProductCollectionViewFlowLayout.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/18.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        self.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 32 - 15) / 2, height: 284)
        self.minimumInteritemSpacing = 15
        self.minimumLineSpacing = 24
        self.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class ListCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.itemSize = CGSize(width: UIScreen.main.bounds.size.width - 16, height: 110)
        self.sectionInset = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 0)
        self.minimumLineSpacing = 24
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
