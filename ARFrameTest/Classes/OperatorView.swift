//
//  OperatorView.swift
//  CollectionLayout
//
//  Created by jianghaibo on 2020/12/1.
//

import Foundation
import UIKit
import SnapKit

class OperatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()
    }
    func initSubview() {
        addSubview(addBtn)
        addSubview(deleteBtn)
        
        addBtn.snp.remakeConstraints({ make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.width.equalToSuperview().dividedBy(2)
        })
        deleteBtn.snp.remakeConstraints({make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(addBtn.snp.right).offset(10)
            make.width.equalToSuperview().dividedBy(2)
        })
    }
    
    lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(addTouched), for: .touchUpInside)
        btn.setTitle("add", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        return btn
    }()
    @objc func addTouched() {
        addTouchBlock?()
    }
    
    lazy var deleteBtn: UIButton = {
        let btn = UIButton()
        btn.addTarget(self, action: #selector(deleteTouched), for: .touchUpInside)
        btn.setTitle("delete", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        
        return btn
    }()
    @objc func deleteTouched() {
        deleteTouchBlock?()
    }
    
    var addTouchBlock: (() -> Void)?
    var deleteTouchBlock: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
