//
//  ColorCell.swift
//  CollectionLayout
//
//  Created by jianghaibo on 2020/11/30.
//

import Foundation
import UIKit

class ColorCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints({ make in
            make.edges.equalToSuperview()
        })
        backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    var model: ContentModel? {
        didSet {
            titleLabel.text = model?.content
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let layoutAttribute = super.preferredLayoutAttributesFitting(layoutAttributes)
        layoutAttribute.bounds.size.height = model?.cellHeight ?? 0
        layoutAttribute.bounds.size.width = width
        
        return layoutAttribute
    }
    
    var width: CGFloat = (UIScreen.main.bounds.width-40)/2
}
