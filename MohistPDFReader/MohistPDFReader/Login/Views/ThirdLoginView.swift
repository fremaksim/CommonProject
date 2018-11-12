//
//  ThirdLoginView.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import SwifterSwift

private let screenWidth = UIScreen.main.bounds.size.width
private let viewWidth = screenWidth - 40

protocol ThirdLoginViewProtocol: class {
   func  didClickItem(name: String)
}

class ThirdLoginView: UIView {
    
    let thirdParties = ["手机号", "QQ", "微信","扫码","微薄","","",""]
    let pageSize  = 4
    
    weak var delegate: ThirdLoginViewProtocol?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "其他登录方式"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var line: UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
        return line
    }()
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: floor(viewWidth / CGFloat(pageSize)), height: 70)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ThirdLoginItemCell.self,
                                forCellWithReuseIdentifier: ThirdLoginItemCell.classReuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate   = self
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage   = 0
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor        = UIColor.purple
        return pageControl
    }()
    
    //MARK: --- Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(line)
        addSubview(collectionView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(20)
        }
        line.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(0.5)
        }
        collectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(line)
            make.bottom.equalToSuperview()
            make.top.equalTo(line.snp.bottom)
        }
        
        if thirdParties.count > pageSize {
            addSubview(pageControl)
            
            let modal = thirdParties.count % pageSize
            if modal == 0 {
                pageControl.numberOfPages = thirdParties.count / pageSize
            }else{
                pageControl.numberOfPages = thirdParties.count / pageSize + 1
            }
            
            pageControl.snp.makeConstraints { (make) in
                make.width.equalTo(5 * pageControl.numberOfPages)
                make.height.equalTo(10)
                make.centerX.equalToSuperview()
                make.top.equalTo(collectionView.snp.bottom)
            }
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
extension ThirdLoginView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.thirdParties.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThirdLoginItemCell.classReuseIdentifier, for: indexPath) as! ThirdLoginItemCell
        let title = thirdParties[indexPath.item]
        cell.nameLabel.text = title
        if title == "" {
            cell.icon.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = thirdParties[indexPath.item]
        guard title != "" else { return }
        delegate?.didClickItem(name: title)
    }
    

}

class ThirdLoginItemCell: UICollectionViewCell { //70 = 10| 30 + 20 |10
    static let classReuseIdentifier = "\(self)"
    
    var icon: UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = UIColor.random
        icon.isUserInteractionEnabled = true
        return icon
    }()
    
    var nameLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont.systemFont(ofSize: 12)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(icon)
        contentView.addSubview(nameLabel)
        icon.layer.cornerRadius = 15
        icon.layer.masksToBounds = true
        icon.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.height.width.equalTo(30)
            make.centerX.equalToSuperview()
        }
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
            make.height.equalTo(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

