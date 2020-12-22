//
//  OneHerivertyLayout.swift
//  PickerDemo
//
//  Created by jianghaibo on 2020/12/4.
//

import Foundation

class OneHorizontalLayout: CustomCollectionViewLayout {
    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 20
    
        colNumber = 1
        
        scrollDirection = .horizontal
        itemSize = CGSize(width: 100, height: 100)
        calculateAttributes()
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        if indexPath == focusIndexPath {
            let x = self.sectionInset.left + (itemSize.width + minimumInteritemSpacing) * CGFloat(indexPath.row)
            attributes.frame = CGRect(x: x, y: sectionInset.top, width: 200, height: 200)
        } else {
            var x = self.sectionInset.left + (itemSize.width + minimumInteritemSpacing) * CGFloat(indexPath.row)
            if indexPath.row > focusIndexPath.row {
               x += 100
            }
            attributes.frame = CGRect(x: x, y: sectionInset.top, width: itemSize.width, height: itemSize.height)
        }
        
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if animationType == .insert {
            if self.insertIndexArr.contains(itemIndexPath) {
                let attribute = self.layoutAttributesForItem(at: itemIndexPath)
                attribute?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                attribute?.alpha = 0
                return attribute
            } else {
                return self.layoutAttributesForItem(at: itemIndexPath)
            }
        }
        return self.layoutAttributesForItem(at: itemIndexPath)
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if animationType == .delete {
            if self.deleteIndexArr.contains(itemIndexPath) {
                let attribute = self.layoutAttributesForItem(at: itemIndexPath)
                attribute?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                attribute?.alpha = 0
                return attribute
            }
        }
        
        return self.layoutAttributesForItem(at: itemIndexPath)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return super.layoutAttributesForElements(in: rect)
    }
    
    override func calculateAttributes() {
        guard let models = dataSources else {
            return
        }
        var tmpAttributeA = [UICollectionViewLayoutAttributes]()
        for (index, _) in models.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let attribute = self.layoutAttributesForItem(at: indexPath) ?? UICollectionViewLayoutAttributes.init()
            tmpAttributeA.append(attribute)
        }
        
        self.attributes = tmpAttributeA
        let lastAttribute = tmpAttributeA.last
        if let attribute = lastAttribute {
            let contentSize = CGSize(width: attribute.frame.maxX + sectionInset.right, height: itemSize.height)
            self.collectionView?.contentSize = contentSize
            itemSize = contentSize
        }
    }
    
    var focusIndexPath = IndexPath(row: 0, section: 0)
}
