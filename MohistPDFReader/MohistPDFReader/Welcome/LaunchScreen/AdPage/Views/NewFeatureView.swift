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
    
    // 自动滚动定时器
    fileprivate var autoScrollTimer: Timer?
    
    fileprivate var countDownTimer: Timer?
    
    // 定时时间
    fileprivate var seconds: Int? {
        didSet {
            guard let timer = self.countDownTimer else { return }
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    lazy var continusButton: UIButton  = {
        let button = UIButton(type: .custom)
        button.setTitle("继续", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        return button
    }()
    
    lazy var loop: Int = {
        return viewModel.loop
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let width: CGFloat = 5.0 * CGFloat(viewModel.numberOfPages)
        let height: CGFloat = 10
        var bottom: CGFloat =  30
        if isIPhoneXSeries() {
            bottom +=  83
        }
        let pageControl = UIPageControl(frame: CGRect(x: (screenWidth - width) * 0.5, y: screenHeight - bottom, width: width, height: height))
        pageControl.numberOfPages  = viewModel.numberOfPages
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
    
    fileprivate var touchCallback: ((String?) -> ())?
    
    public static func show(on view: UIView? = nil,viewModel: NewFeatureViewModel, touchCallback: @escaping ((String?) -> ()), dissmissCallback: @escaping( () ->() )){
        
        let newFeatureView = NewFeatureView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), viewModel: viewModel)
        newFeatureView.dismissCallback = dissmissCallback
        newFeatureView.touchCallback   = touchCallback
        
        if view == nil {
            guard let keyWindow = UIApplication.shared.keyWindow else {
                return
            }
            keyWindow.addSubview(newFeatureView)
        }else {
            view!.addSubview(newFeatureView)
        }
    }
    
    private func addAutoScrollTimer() {
        self.autoScrollTimer = Timer.scheduledTimer(timeInterval:3.0, target: self, selector: #selector(autoScrollTimerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(autoScrollTimer!, forMode: .common)
        
    }
    
    @objc private func autoScrollTimerAction() {
        
        let page = 0
        let offsetX = CGFloat((page + 1)) * self.bounds.size.width
        let offset  = CGPoint(x: offsetX + self.collectionView.contentOffset.x, y: 0)
        
        
        self.collectionView.setContentOffset(offset, animated: true)
    }
    
    private func addCountDownTimer() {
        self.countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDownTimerAction), userInfo: nil, repeats: true)
        skipButton.setTitle("跳过广告\(viewModel.countDownTime ?? 3)s", for: .normal)
        //        RunLoop.current.add(autoScrollTimer!, forMode: .common)
        self.seconds = viewModel.countDownTime
    }
    
    @objc private func countDownTimerAction() {
        guard var seconds = self.seconds else { return }
        seconds -= 1
        self.seconds = seconds
        skipButton.setTitle("跳过广告\(seconds)s", for: .normal)
        if seconds == 0 { skipButtonAction() }
    }
    
    @objc private func removeCountDownTimer(){
        self.countDownTimer?.invalidate()
        self.countDownTimer = nil
    }
    
    private func removerAutoScrollTimer(){
        self.autoScrollTimer?.invalidate()
        self.autoScrollTimer = nil
    }
    
    deinit {
        self.removerAutoScrollTimer()
        self.removeCountDownTimer()
    }
    
    
    public init(frame: CGRect, viewModel: NewFeatureViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        addSubview(skipButton)
        
        addSubview(continusButton)
        
        if !viewModel.isPageControlHidden {
            addSubview(pageControl)
            self.collectionView.scrollToItem(at: IndexPath(item: loop / 2, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        if viewModel.isTimerAutoScrolling {
            addAutoScrollTimer()
        }
        
        if viewModel.showTimerCountDown {
            addCountDownTimer()
        }
        
        
        //layout
        let buttonWidth: CGFloat  = 80
        let buttonHeight: CGFloat = 30
        
        
        
        NSLayoutConstraint.activate([
            skipButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            skipButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            skipButton.topAnchor.constraint(equalTo: self.topAnchor, constant: buttonHeight),
            skipButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(0.5 * buttonWidth )),
            
            ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --- Event Response
    @objc fileprivate func skipButtonAction() {
        
        removeCountDownTimer()
        removerAutoScrollTimer()
        
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
        return viewModel.numberOfPages * loop
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewFeatureImageCell.reuseIdentifier, for: indexPath) as! NewFeatureImageCell
        
        if viewModel.isShortVideo {
            collectionView.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            cell.backgroundColor             = .clear
            cell.pictureView.image           = nil
            
        }else {
            if let images = viewModel.imageNames {
                let imageName = images[indexPath.item % viewModel.numberOfPages]
                cell.pictureView.image = UIImage(named: imageName)
            }else if let imageUrls = viewModel.imageURLs {
                cell.pictureView.kf.setImage(with: URL(string: imageUrls[indexPath.item % viewModel.numberOfPages]))
            }else {
                cell.pictureView.image = nil
            }
        }
        
        return cell
    }
}

extension NewFeatureView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let webURLs = viewModel.webURLs else { return }
        let webURL = webURLs[indexPath.item % viewModel.numberOfPages]
        guard viewModel.validWebURL(webURL: webURL) else { return }
        
        // web 跳转
        touchCallback?(webURL)
        
        skipButtonAction()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollWidth = collectionView.bounds.size.width
        let number = scrollView.contentOffset.x / scrollWidth
        let page =  Int(round(number)) % viewModel.numberOfPages
        pageControl.currentPage = page
        
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removerAutoScrollTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addAutoScrollTimer()
    }
}


public class NewFeatureImageCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(self)"
    
    // Properties
    var pictureView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
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
