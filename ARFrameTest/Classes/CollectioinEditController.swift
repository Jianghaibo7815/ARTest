//
//  CollectioinEditController.swift
//  CollectionLayout
//
//  Created by jianghaibo on 2020/11/30.
//

import Foundation
import UIKit

class CollectionEditController: UIViewController {
    deinit {
        print("deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        initSubview()
        configData()
        layout.appedItems(dataSource)
        if let datas = dataSource {
            oneHorizontalLayout.dataSources = datas
        }
        colletionView.reloadData()
    }
    
    private func initSubview() {
        view.addSubview(colletionView)
        view.addSubview(operatorView)
        
        operatorView.snp.remakeConstraints({ make in
            make.bottom.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.width.equalTo(130)
        })
    }
    
    lazy var colletionView: UICollectionView = createCollectionView()
    
    private func createCollectionView() -> UICollectionView {
//        let layout = self.layout
        let layout = self.oneHorizontalLayout
        
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.contentInsetAdjustmentBehavior = .never
        cv.alwaysBounceHorizontal = true
        cv.alwaysBounceVertical = true
        cv.isScrollEnabled = true
        cv.contentInset = UIEdgeInsets(top: 20, left: 10, bottom: 90, right: 10)
        
        cv.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        
        return cv
    }
    private var layout: TwoColViewLayout = {
        let layout = TwoColViewLayout()
        
        return layout
    }()
    
    private var oneHorizontalLayout: OneHorizontalLayout = {
        let layout = OneHorizontalLayout()
        layout.colNumber = 1
        
        return layout
    }()
    
    lazy var operatorView: OperatorView = {
        let view = OperatorView()
        
        view.addTouchBlock = { [weak self] in
            self?.addRoundItem()
        }
        view.deleteTouchBlock = { [weak self] in
            self?.deleteRoundItem()
        }
        return view
    }()
    private func addRoundItem() {
        //TODO 随机添加一个元素
        let model = roundModel()
        
        dataSource?.insert(model, at: 0)
        layout.dataSources = dataSource
        oneHorizontalLayout.dataSources = dataSource
        let paths = [IndexPath(row: 0, section: 0)]
        insertPaths.append(contentsOf: paths)
        colletionView.performBatchUpdates({
            colletionView.insertItems(at: paths)
        }, completion: { [weak self] result in
            self?.insertPaths.removeAll()
        })
    }
    private func deleteRoundItem() {
        //TODO 随机删除一个元素
        guard let models = dataSource, models.count > 0 else {
            return
        }
//        let total = UInt32(models.count)
//        let index = arc4random() % total
        let index = 0
        
        dataSource?.remove(at: Int(index))
        layout.dataSources = dataSource
        oneHorizontalLayout.dataSources = dataSource
        let paths = [IndexPath(row: Int(index), section: 0)]
        self.deletePaths.append(contentsOf: paths)
        
        colletionView.performBatchUpdates({
            colletionView.deleteItems(at: paths)
        }, completion: { [weak self] _ in
            self?.deletePaths.removeAll()
        })
        
//        configData()
//        layout.dataSources = dataSource
//        colletionView.reloadData()
    }
    
    var insertPaths: [IndexPath] = [IndexPath]()
    var deletePaths: [IndexPath] = [IndexPath]()
    
    
    private func configData() {
        dataSource = [ContentModel]()
        for _ in 0..<10 {
            let item = roundModel()
            dataSource?.append(item)
        }
        
        layout.insertPathCheckBlock = { [weak self] indexPath in
            return self?.insertPaths.contains(indexPath) ?? false
        }
        layout.deletedPathCheckBlock = { [weak self] indexPath in
            return self?.deletePaths.contains(indexPath) ?? false
        }
    }
    func roundModel() -> ContentModel {
        let random1 = arc4random() % 100
        let text = "\(random1)"
        let height = max(50, CGFloat(arc4random()%200))
        
        let model = ContentModel(content: text, cellHeight: height)
        return model
    }
    
    var dataSource: [ContentModel]?
}

extension CollectionEditController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < dataSource?.count ?? 0 else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell
        let model = dataSource?[indexPath.item]
        guard let c = cell, let m = model else {
            return UICollectionViewCell()
        }
        
        c.model = m
        return c
    }
    
}

struct ContentModel: LayoutModel {
    func heightForIndexPath(_ indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    var content: String
//    var background: UIColor
    var cellHeight: CGFloat
}
