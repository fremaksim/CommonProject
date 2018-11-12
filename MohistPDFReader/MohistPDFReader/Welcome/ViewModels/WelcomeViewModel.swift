//
//  WelcomeViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation
import UIKit

struct WelcomeViewModel {
    
    var title: String {
        return "Welcome"
    }
    
    var backgroundColor: UIColor {
        return .white
    }
    
//    var pageIndicatorTintColor: UIColor {
//        return UIColor(hex: "c3dbee")
//    }
//
//    var currentPageIndicatorTintColor: UIColor {
//        return UIColor(hex: "438FCA")
//    }
    
    var numberOfPages = 0
    var currentPage = 0
}
