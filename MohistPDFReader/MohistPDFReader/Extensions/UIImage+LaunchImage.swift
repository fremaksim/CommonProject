//
//  UIImage+LaunchImage.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    /// 获取应用的启动图片
    ///
    /// - Returns: launchImage
    static func fetchLaunchImage() -> UIImage? {
        
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        
        if let launchScreen = infoDictionary["UILaunchStoryboardName"] as? String { // from LaunchScreen.storyborad
            guard let launchScreenViewController = UIStoryboard(name: launchScreen, bundle: nil).instantiateInitialViewController(),
                let launchScreenImageView = launchScreenViewController.view.subviews.first as? UIImageView,
                let image = launchScreenImageView.image else {
                    return nil
            }
            return image
        }
        
        if let launchImageDictionary = infoDictionary["UILaunchImages"] as? [[String: Any]] { // from Assets --> LaunchImage
            for dict in launchImageDictionary  {
                if let imageName = dict["UILaunchImageName"] as? String {
                    return UIImage(named: imageName)
                }
            }
            return nil
        }
        return nil
        
        /*
         ---Only Portrait
         UILaunchImages [0 : 2 elements
         - key : UILaunchImageOrientation
         - value : Portrait
         ▿ 1 : 2 elements
         - key : UILaunchImageName
         - value : LaunchImage-2-700-568h
         ▿ 2 : 2 elements
         - key : UILaunchImageSize
         - value : {320, 568}
         ▿ 3 : 2 elements
         - key : UILaunchImageMinimumOSVersion
         - value : 7.0]
         */
    }
}

