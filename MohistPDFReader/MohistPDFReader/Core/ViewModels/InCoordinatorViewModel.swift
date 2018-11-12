//
//  InCoordinatorViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation
import UIKit

struct InCoordinatorViewModel {
    
    var homeBarItem: UITabBarItem {
        return UITabBarItem(
            title: "主页",
            image: R.image.home(),
            selectedImage: nil
        )
    }
    
    var discoveryBarItem: UITabBarItem {
        return UITabBarItem(
            title: "发现",
            image: R.image.discovery(),
            selectedImage: nil
        )
    }
    
    var profileBarItem: UITabBarItem {
        return UITabBarItem(
            title: "我的",
            image: R.image.profile(),
            selectedImage: nil
        )
    }
    
}

