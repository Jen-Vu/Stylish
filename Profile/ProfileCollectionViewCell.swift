//
//  CollectionViewCell.swift
//  STYLiSH
//
//  Created by littlema on 2019/7/12.
//  Copyright © 2019 littema. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var view = UIView()
    var image = UIImageView()
    var label: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.greyStylish
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.view = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.addSubview(view)
        self.view.addSubview(image)
        self.view.addSubview(label)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 24 / 60),
            self.image.heightAnchor.constraint(equalTo: image.widthAnchor),
            self.image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.image.topAnchor.constraint(equalTo: view.topAnchor),
            self.label.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.label.heightAnchor.constraint(equalToConstant: 19),
            self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
}
