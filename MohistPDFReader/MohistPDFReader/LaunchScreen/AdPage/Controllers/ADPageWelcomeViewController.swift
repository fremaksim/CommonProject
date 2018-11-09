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
        //TODO: -- 不应该取 first
        if let url = viewModel.page.pageItems?.first?.videoURL{
            let player = AVPlayer(url: url)
            vc.player = player
            vc.showsPlaybackControls = false
            NotificationCenter.default.addObserver(self, selector: #selector(avPlayerDidEndTime),
                                                   name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        }
        return vc
    }()
    
    fileprivate var touchCallback: ((String?) -> ())?
    
    //MARK: --- Life Cycle
    init(viewModel: ADPageViewWelcomeViewModel, touchCallback: @escaping((String?) -> ())) {
        self.viewModel = viewModel
        self.touchCallback = touchCallback
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        loadWelcomeViewStyle()
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
        print("\(self) deinit")
    }
    
    //MARK: --- Prive Methods
    @objc private func avPlayerDidEndTime(){
        
        guard  let player = avPlayerViewController.player else { return }
        
        player.seek(to: CMTime.zero )
        player.play()
        
    }
    
    // 广告 样式
    private func loadAdViewStyle(){
        
        switch viewModel.page.contentType {
            
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
        
    }
    // 欢迎样式
    private func loadWelcomeViewStyle(){
        
        switch viewModel.page.contentType {
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
        loadNewFeatureView()
    }
    
    private func loadVideoPlayer(){
        
        addChild(avPlayerViewController)
        avPlayerViewController.view.frame = view.bounds
        view.addSubview(avPlayerViewController.view)
        avPlayerViewController.player?.play()
        
    }
    
    private func loadNewFeatureView(){
        
        
        
        let newFeatureModel = NewFeatureViewModel(type: viewModel.guideType ,page: viewModel.page)
        
        NewFeatureView.show(viewModel: newFeatureModel, touchCallback: { [weak self] webURL in
            self?.touchCallback?(webURL)
        }) {
            [weak self] in
            self?.removeSelf()
        }
    }
    
    private func removeSelf() {
        
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}
