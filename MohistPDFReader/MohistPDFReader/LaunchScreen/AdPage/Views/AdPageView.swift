//
//  AdPageView.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import Kingfisher

// 单个图片
// 多个图片动画
// 小视频
// 跳过
// 定时
// 点击跳连接

// IMG_0777 - IMG_0782
public class AdPageView: UIView {
    
    let viewModel: AdPageViewModel
    
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    // 广告图片
    fileprivate lazy var adImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAdImage))
        imageView.addGestureRecognizer(tap)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // 跳过按钮
    fileprivate lazy var skipButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("跳过", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.backgroundColor = UIColor(white: 0.2, alpha: 0.6)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(skipButtonAction), for: .touchUpInside)
        return button
        
    }()
    
    fileprivate var webURLString: String? {
        return viewModel.webURL
    }
    
    // 定时器
    fileprivate var timer: Timer?
    
    // 定时时间
    fileprivate var seconds: Int? {
        didSet {
            guard let timer = self.timer else { return }
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    fileprivate var touchCallback: ((String?) -> ())?
    fileprivate var dismissCallback: ( () -> Void )?
    
    //MARK: --- Life Cycle
    init(viewModel: AdPageViewModel) {
        self.viewModel = viewModel
        
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        self.initial()
        
        // 赋值
        seconds = viewModel.timeInterval
    }
    
    private func initial() {
        
        backgroundColor = UIColor.white
        
        addSubview(adImageView)
        addSubview(skipButton)
        
        //layout
        let buttonWidth: CGFloat  = 60
        let buttonHeight: CGFloat = 30
        
        NSLayoutConstraint.activate([
            skipButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            skipButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            skipButton.topAnchor.constraint(equalTo: self.topAnchor, constant: buttonHeight),
            skipButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(0.5 * buttonWidth )),
            
            adImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            adImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            adImageView.topAnchor.constraint(equalTo: topAnchor),
            adImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: --- Public Method
    
    /// 展示广告视图
    ///
    /// - Parameters:
    ///   - view: 目标视图 default is KeyWindow
    ///   - viewModel: AdViewModel
    ///   - touchCallback: 点击广告跳转 webView
    public static func show(on view: UIView? = nil,
                            viewModel: AdPageViewModel,
                            touchCallback: @escaping ((String?) -> ()), dismissCallback: @escaping ( () -> Void )) {
        
        let adPageView = AdPageView(viewModel: viewModel)
        adPageView.touchCallback = touchCallback
        adPageView.dismissCallback = dismissCallback
        adPageView.timer = Timer.scheduledTimer(timeInterval: 1.0, target: adPageView, selector: #selector(timerCountDown), userInfo: nil, repeats: true)
        switch viewModel.contentType {
        case .singleImage:
            if let imageUrlString = viewModel.imageURLs?.first,
                let imageURL = URL(string: imageUrlString) {
                //                adPageView.adImageView.kf.setImage(with: URL(string: imageUrlString))
                DispatchQueue.global().async {
                    do{
                        let data = try Data(contentsOf: imageURL)
                        DispatchQueue.main.async {
                            adPageView.adImageView.image = UIImage(data: data)
                        }
                    }catch {
                        print(error)
                    }
                }
            }
        case .multiImages:
            guard let imageNames = viewModel.imageNames else { return }
            let images: [UIImage] = imageNames.compactMap{ UIImage(named: $0) }
            adPageView.adImageView.animationImages   = images
            adPageView.adImageView.animationDuration = TimeInterval(viewModel.timeInterval)
            adPageView.adImageView.animationRepeatCount = 0
            adPageView.adImageView.startAnimating()
            
        case .shortVideo:
            print("短视频")
            adPageView.backgroundColor = UIColor.clear
        case .welcome:
            print("欢迎页")
            adPageView.backgroundColor = UIColor.clear
        }
        
        if view == nil {
            guard let keyWindow = UIApplication.shared.keyWindow else {
                return
            }
            keyWindow.addSubview(adPageView)
        }else {
            view!.addSubview(adPageView)
        }
    }
    
    //MARK: --- Event Response
    @objc fileprivate func skipButtonAction() {
        timer?.invalidate()
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { _ in 
            self.removeFromSuperview()
        }
        dismissCallback?()
    }
    
    @objc fileprivate func tapAdImage() {
        touchCallback?(webURLString)
        skipButtonAction()
    }
    
    @objc fileprivate func timerCountDown() {
        guard var seconds = self.seconds else { return }
        seconds -= 1
        self.seconds = seconds
        skipButton.setTitle("跳过\(seconds)", for: .normal)
        if seconds == 0 { skipButtonAction() }
    }
    
    
    
}
