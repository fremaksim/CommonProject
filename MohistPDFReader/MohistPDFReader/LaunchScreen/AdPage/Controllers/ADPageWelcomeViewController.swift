//
//  ADPageViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import AVKit

public class ADPageWelcomeViewController: UIViewController {
    
    private let viewModel: ADPageViewWelcomeViewModel
    
    private lazy var  avPlayerViewController: AVPlayerViewController = {
        let vc = AVPlayerViewController()
        if let url = Bundle.main.url(forResource: "keep", withExtension: "mp4") {
            let player = AVPlayer(url: url)
            vc.player = player
            vc.showsPlaybackControls = false
            NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidEndTime),
                                                   name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
        return vc
    }()
    
    //MARK: --- Life Cycle
    init(viewModel: ADPageViewWelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        switch viewModel.guideType {
        case .ad:
            self.loadAdViewStyle()
        case .welcome:
            self.loadWelcomeViewStyle()
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    deinit {
        
    }
    
    //MARK: --- Prive Methods
    @objc private func avPlayerDidEndTime(){
        
        guard  let player = avPlayerViewController.player else { return }
        
        player.seek(to: CMTime.zero )
        player.play()
        
    }
    
    // 广告 样式
    private func loadAdViewStyle(){
        
        switch viewModel.contentType {
            
        case .singleImage:
            print("ad -- singleImage")
        case .multiImages:
            print("ad -- multiImages")
        case .shortVideo:
            print("ad -- shortVideo")
            loadVideoPlayer()
        case .welcome:
            print("ad -- welcom -- heihei")
        }
        
        loadUserInteractiveView()
        
    }
    // 欢迎样式
    private func loadWelcomeViewStyle(){
        
        switch viewModel.contentType {
        case .singleImage:
            print("ad -- singleImage")
        case .multiImages:
            print("ad -- multiImages")
        case .shortVideo:
            print("ad -- shortVideo")
            loadVideoPlayer()
        case .welcome:
            print("ad -- welcom -- heihei")
        }
        //        loadVideoPlayer()
        loadNewFeatureView()
    }
    
    private func loadVideoPlayer(){
        
        addChild(avPlayerViewController)
        avPlayerViewController.view.frame = view.bounds
        view.addSubview(avPlayerViewController.view)
        avPlayerViewController.player?.play()
        
    }
    
    private func loadUserInteractiveView() {
        
        // 切换 type 单图，多图
        let pageViewModel = AdPageViewModel(page: AdPage.testPage(type: viewModel.contentType))
        
        AdPageView.show(viewModel: pageViewModel, touchCallback: {  [weak self] (urlString) in
            let adWeb = AdWeb()
            adWeb.url = urlString
            let webViewModel = AdWebViewModel(adWeb: adWeb)
            let webViewController = AdWebViewController(viewModel: webViewModel)
            
            self?.navigationController?.pushViewController(webViewController, animated: true)
            
        }) { [weak self] in
            
            self?.removeSelf()
        }
    }
    
    private func loadNewFeatureView(){
        
        var images: [UIImage] = []
        for i in 0..<6 {
            if let image = UIImage(named: "IMG_07\(77 + i)") {
                images.append(image)
            }
        }
        
        let newFeatureModel = NewFeatureViewModel(images: images)
        
        NewFeatureView.show(viewModel: newFeatureModel) {
            [weak self] in
            self?.removeSelf()
        }
    }
    
    private func removeSelf() {
        
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
