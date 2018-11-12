//
//  NewFeatureViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/8.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

fileprivate let NewFeatureViewModelEmptyString = "EmptyHolder"
fileprivate let NewFeatureViewModelEmptyURL    = URL(string: "EmptyHolder")
public class NewFeatureViewModel {
    
    private let guideType: GuideType
    
    private let contentType: AdPageContentType
    
    private let page: AdPage
    
    init(type: GuideType, page: AdPage) {
        self.guideType = type
        self.contentType = page.contentType
        self.page = page
    }
    
    var isPageControlHidden: Bool {
        return contentType == .singleImage || contentType == .shortVideo
    }
    
    var isTimerAutoScrolling: Bool {
        return !isPageControlHidden
    }
    
    var showTimerCountDown: Bool {
        return guideType == .ad
    }
    var countDownTime: Int? {
        return page.timeInterval
    }
    
    var numberOfPages: Int {
        if isPageControlHidden {
            return 1
        }
        return page.pageItems?.count ?? 0
    }
    var isShortVideo: Bool {
        return contentType == .shortVideo
    }
    
    var loop: Int {
        if isPageControlHidden {
            return 1
        }
        return numberOfPages * 100000 * 2
    }
    // 使用 NewFeatureViewModelEmptyString 保证 one to one
    var imageNames: [String]? {
        return page.pageItems?.compactMap{ return $0.imageName ?? NewFeatureViewModelEmptyString }
    }
    
    var imageURLs: [String]? {
        return page.pageItems?.compactMap{ return $0.imageURL ?? NewFeatureViewModelEmptyString }
    }
    var videos: [URL]? {
        return page.pageItems?.compactMap{ return $0.videoURL ?? NewFeatureViewModelEmptyURL }
    }
    
    var webURLs: [String]? {
        return page.pageItems?.compactMap{ return $0.webURL ?? NewFeatureViewModelEmptyString }
    }
    
    
    func validWebURL(webURL: String) -> Bool {
        if webURL == NewFeatureViewModelEmptyString { return false }
        guard let _ = URL(string: webURL) else { return false }
        return true
    }
    
    
}
