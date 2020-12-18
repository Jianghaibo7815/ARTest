//
//  TwoColViewLayout.swift
//  CollectionLayout
//
//  Created by jianghaibo on 2020/11/30.
//

import Foundation
import UIKit
//
class TwoColViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        minimumLineSpacing = 20
        minimumInteritemSpacing = 15
        
        itemSize = CGSize(width: width, height: 100)
//        estimatedItemSize = CGSize(width: width, height: 100)
    }
    
//    override var collectionViewContentSize: CGSize {
//        // TODO 展示区域
//
//        return CGSize.zero
//    }
//
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)

        return attribute
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
    var animationType: UICollectionViewUpdateItem.Action = .none
    var deleteIndexArr: [IndexPath] = [IndexPath]()
    var insertIndexArr: [IndexPath] = [IndexPath]()
    var reloadIndexArr: [IndexPath] = [IndexPath]()
    var beforeMoveIndexArr: [IndexPath] = [IndexPath]()
    var afterMoveIndexArr: [IndexPath] = [IndexPath]()
    
    private func resetUpdateIndexPaths() {
        animationType = .none
        deleteIndexArr.removeAll()
        insertIndexArr.removeAll()
        reloadIndexArr.removeAll()
        beforeMoveIndexArr.removeAll()
        afterMoveIndexArr.removeAll()
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        resetUpdateIndexPaths()
        
        updateItems.forEach({ item in
            switch item.updateAction {
            case .delete:
                if let path = item.indexPathBeforeUpdate {
                    deleteIndexArr.append(path)
                    animationType = .delete
                }
            case .insert:
                if let path = item.indexPathAfterUpdate {
                    insertIndexArr.append(path)
                    animationType = .insert
                }
            case .reload:
                if let path = item.indexPathAfterUpdate {
                    reloadIndexArr.append(path)
                    animationType = .reload
                }
            case .move:
                if let before = item.indexPathBeforeUpdate, let after = item.indexPathAfterUpdate {
                    beforeMoveIndexArr.append(before)
                    afterMoveIndexArr.append(after)
                    animationType = .move
                }
            case .none:
                animationType = .none
            @unknown default:
                print("unknown default")
            }
        })
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        switch animationType {
        case .insert:
            let isInsertPath = insertIndexArr.contains(itemIndexPath)
            if  isInsertPath {
                attribute?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                attribute?.alpha = 0
            } else {
                attribute?.frame = frameForIndexPath(IndexPath(row: itemIndexPath.row, section: itemIndexPath.section))
            }
        case .delete:
            attribute?.frame = frameForIndexPath(IndexPath(row: itemIndexPath.row, section: itemIndexPath.section))
        default: break
            
        }
        return attribute
    }
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        
        switch animationType {
        case .insert:
            attribute?.frame = frameForIndexPath(IndexPath(row: itemIndexPath.row, section: itemIndexPath.section))
        case .delete:
            let isDeletedPath = deleteIndexArr.contains(itemIndexPath)
            if isDeletedPath {
                attribute?.transform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                attribute?.alpha = 0
            } else {
                attribute?.frame = frameForIndexPath(IndexPath(row: itemIndexPath.row, section: itemIndexPath.section))
                if attribute?.frame == CGRect.zero {
                    attribute?.frame = attributes?.last?.frame ?? CGRect.zero
                    attribute?.alpha = 0.99
                }
            }
        default:
            break
        }
        
        return attribute
    }
    
    private func frameForIndexPath(_ indexPath: IndexPath) -> CGRect {
//        return layoutAttributesForItem(at: indexPath)?.frame ?? CGRect.zero
        return attributes?.first(where: { (item) -> Bool in
            return item.indexPath.item == indexPath.item
        })?.frame ?? CGRect.zero
    }

    var width: CGFloat = (UIScreen.main.bounds.width-40)/2
    var colNumber: Int = 2
    
    var oldAttributes: [UICollectionViewLayoutAttributes]?
    var attributes: [UICollectionViewLayoutAttributes]?
    var dataSources: [ContentModel]? {
        didSet {
            calcuteAttribute()
        }
    }
    
    func appedItems(_ items: [ContentModel]?) {
        if dataSources == nil {
            dataSources = [ContentModel]()
        }
        guard let models = items else {
            return
        }
        dataSources?.append(contentsOf: models)
        calcuteAttribute()
    }
    private func calcuteAttribute() {
        guard let models = dataSources else {
            return
        }
        // 对列的长度进行累计
        var colHeightArray: [CGFloat] = [0, 0]
        
        var attributes = [UICollectionViewLayoutAttributes]()
        for (index, model) in models.enumerated() {
            let attribute = self.layoutAttributesForItem(at: IndexPath(row: index, section: 0))
            guard let layoutAttr = attribute else {
                continue
            }
            
            var nShortIndex = 0
            var shortHeight = colHeightArray[nShortIndex]
            for i in 1..<colHeightArray.count {
                let nextHeight = colHeightArray[i]
                if shortHeight > nextHeight {
                    nShortIndex = i
                    shortHeight = nextHeight
                }
            }
            
            let x = self.sectionInset.left + (width + minimumInteritemSpacing) * CGFloat(nShortIndex)
            let y = shortHeight + minimumLineSpacing
            let height = model.cellHeight
            
            let frame = CGRect(x: x, y: CGFloat(y), width: width, height: height)
            layoutAttr.frame = frame
            colHeightArray[nShortIndex] = frame.origin.y + height
            
            attributes.append(layoutAttr)
        }
        self.oldAttributes = self.attributes
        self.attributes = attributes
    }
    
    var insertPathCheckBlock: ((IndexPath) -> Bool)?
    var deletedPathCheckBlock: ((IndexPath) -> Bool)?
}
