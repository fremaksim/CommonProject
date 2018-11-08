//
//  NewFeatureView.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/8.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import Kingfisher

private let screenWidth  = UIScreen.main.bounds.size.width
private let screenHeight = UIScreen.main.bounds.size.height

public class NewFeatureView: UIView {
    
    let viewModel: NewFeatureViewModel
    
    // 定时器
    fileprivate var timer: Timer?
    
    lazy var continusButton: UIButton  = {
        let button = UIButton(type: .custom)
        button.setTitle("继续", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        return button
    }()
    
    lazy var loop: Int = {
        return viewModel.imageCount * 100000 * 2
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let width: CGFloat = 5.0 * CGFloat(viewModel.imageCount)
        let height: CGFloat = 10
        var bottom: CGFloat =  30
        if isIPhoneXSeries() {
            bottom +=  83
        }
        let pageControl = UIPageControl(frame: CGRect(x: (screenWidth - width) * 0.5, y: screenHeight - bottom, width: width, height: height))
        pageControl.numberOfPages  = viewModel.imageCount
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.purple
        pageControl.currentPageIndicatorTintColor = UIColor.red
        return pageControl
    }()
    
    lazy var skipButton: UIButton = {
        let skipButton = UIButton(type: .custom)
        skipButton.setTitle("跳过", for: .normal)
        skipButton.titleLabel?.textColor = UIColor.white
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        skipButton.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        skipButton.layer.cornerRadius = 4
        skipButton.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        return skipButton
    }()
    
    lazy var collectionView: UICollectionView = {
        
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets.zero
        collectionView.register(NewFeatureImageCell.self, forCellWithReuseIdentifier: NewFeatureImageCell.reuseIdentifier)
        collectionView.delegate   = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight)
        return layout
    }()
    
    fileprivate var dismissCallback: ( () -> Void )?
    
    public static func show(on view: UIView? = nil,viewModel: NewFeatureViewModel, dissmissCallback: @escaping( () ->() )){
        let newFeatureView = NewFeatureView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), viewModel: viewModel)
        newFeatureView.dismissCallback = dissmissCallback
        
        if view == nil {
            guard let keyWindow = UIApplication.shared.keyWindow else {
                return
            }
            keyWindow.addSubview(newFeatureView)
        }else {
            view!.addSubview(newFeatureView)
        }
        
    }
    
    private func addTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerCountDown), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    @objc private func timerCountDown() {
        
        let page = 0
        let offsetX = CGFloat((page + 1)) * self.bounds.size.width
        let offset  = CGPoint(x: offsetX + self.collectionView.contentOffset.x, y: 0)
        
        
        self.collectionView.setContentOffset(offset, animated: true)
        
    }
    
    private func removerTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    
    deinit {
        self.removerTimer()
    }
    
    
    public init(frame: CGRect, viewModel: NewFeatureViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        addSubview(skipButton)
        
        addSubview(continusButton)
        
        addSubview(pageControl)
        
        
        self.collectionView.scrollToItem(at: IndexPath(item: loop / 2, section: 0), at: .centeredHorizontally, animated: true)
        
        
        
        //layout
        let buttonWidth: CGFloat  = 60
        let buttonHeight: CGFloat = 30
        
        
        
        NSLayoutConstraint.activate([
            skipButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            skipButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            skipButton.topAnchor.constraint(equalTo: self.topAnchor, constant: buttonHeight),
            skipButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(0.5 * buttonWidth )),
            
            ])
        
        addTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --- Event Response
    @objc fileprivate func skipButtonAction() {
        
        removerTimer()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
        dismissCallback?()
    }
    
    //MARK: --- Help Methods
    private func isIPhoneXSeries() -> Bool{
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return false
        }
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
                let mainWindow = window,mainWindow.safeAreaInsets.bottom > 0.0{
                return true
            }
            return false
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
}

extension NewFeatureView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageCount * loop
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewFeatureImageCell.reuseIdentifier, for: indexPath) as! NewFeatureImageCell
        if let images = viewModel.images {
            cell.pictureView.image = images[indexPath.item % viewModel.imageCount]
        }else if let imageUrls = viewModel.imageUrls {
            cell.pictureView.kf.setImage(with: URL(string: imageUrls[indexPath.item]))
        }else {
            cell.pictureView.image = nil
        }
        return cell
    }
}

extension NewFeatureView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollWidth = collectionView.bounds.size.width
        let number = scrollView.contentOffset.x / scrollWidth
        let page =  Int(round(number)) % viewModel.imageCount
        pageControl.currentPage = page
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removerTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}


public class NewFeatureImageCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(self)"
    
    // Properties
    var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: ---  Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(pictureView)
        NSLayoutConstraint.activate([
            pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pictureView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
