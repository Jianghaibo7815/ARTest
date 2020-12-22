//
//  CostomCollectionViewLayout.swift
//  PickerDemo
//
//  Created by jianghaibo on 2020/12/2.
//

import Foundation

protocol LayoutModel {
    func heightForIndexPath(_ indexPath: IndexPath) -> CGFloat
}

class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
    }
    
    var animationType: UICollectionViewUpdateItem.Action = .none
    var deleteIndexArr: [IndexPath] = [IndexPath]()
    var insertIndexArr: [IndexPath] = [IndexPath]()
    var reloadIndexArr: [IndexPath] = [IndexPath]()
    var beforeMoveIndexArr: [IndexPath] = [IndexPath]()
    var afterMoveIndexArr: [IndexPath] = [IndexPath]()
    
    var width: CGFloat = (UIScreen.main.bounds.width-40)/2 {
        didSet {
            calculateAttributes()
        }
    }
    var colNumber: Int? = 0
    
    var attributes: [UICollectionViewLayoutAttributes]?
    lazy var dataSources: [LayoutModel]? = [LayoutModel]() {
        didSet {
            calculateAttributes()
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
    
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
        
        
        return nil
    }
    
    @objc func calculateAttributes() {
        guard let models = dataSources, let columCount = colNumber else {
            return
        }
        // 对列的长度进行累计
        var colHeightArray: [CGFloat] = [0, 0, 0, 0, 0]
        
        var attributes = [UICollectionViewLayoutAttributes]()
        for (index, model) in models.enumerated() {
            let curIndexPath = IndexPath(row: index, section: 0)
            let attribute = self.layoutAttributesForItem(at: curIndexPath)
            guard let layoutAttr = attribute else {
                continue
            }
            
            var nShortIndex = 0
            var shortHeight = colHeightArray[nShortIndex]
            for i in 1..<columCount {
                let nextHeight = colHeightArray[i]
                if shortHeight > nextHeight {
                    nShortIndex = i
                    shortHeight = nextHeight
                }
            }
            
            let x = self.sectionInset.left + (width + minimumInteritemSpacing) * CGFloat(nShortIndex)
            let y = shortHeight + minimumLineSpacing
            let height = model.heightForIndexPath(curIndexPath)
            
            let frame = CGRect(x: x, y: CGFloat(y), width: width, height: height)
            layoutAttr.frame = frame
            colHeightArray[nShortIndex] = frame.origin.y + height
            
            attributes.append(layoutAttr)
        }
        
        self.attributes = attributes
    }
    
}
