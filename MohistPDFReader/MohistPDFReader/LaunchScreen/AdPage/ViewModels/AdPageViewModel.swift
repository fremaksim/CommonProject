//
//  AdViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation
import UIKit

public class AdPageViewModel {
    
    private let page: AdPage
    
    public var imageURLs: [String]?{
        return page.imageURLs
    }
    public var webURL: String? {
        return page.webURL
    }
    public var timeInterval: Int {
        return page.timeInterval
    }
    
    public var contentType: AdPageContentType {
        return page.contentType
    }
    public var imageNames: [String]? {
        return page.imageNames
    }
    
    init(page: AdPage) {
        self.page = page
    }
    
    // 请求网络广告，缓存本地
    public func fetchNextAd(){
        
        // 模拟网络请求所得数据
        let data = Data()
    
        
        
    }
    // 从本地缓存抓取数据
    
}

