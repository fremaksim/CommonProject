//
//  AdPageModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation
import UIKit

public enum AdPageContentType: String, Codable {
    
    case singleImage
    case multiImages
    case shortVideo
    
    case welcome
    
}


public class AdPage: Codable {
    
    var contentType: AdPageContentType = .singleImage
    
    // 本地图片名
    var imageNames: [String]?
    
    // 网络图片
    var imageURLs: [String]?
    
    // 跳转链接
    var webURL: String?
    
    // 视频链接
    var videoURL: String?
    
    // 时间间隔
    var timeInterval: Int = 3
    
    
    var localPath: String?
    
    // 测试用
    static func testPage(type: AdPageContentType = .singleImage) -> AdPage {
        
        let adPage = AdPage()
        adPage.contentType = type
        adPage.imageURLs = ["http://192.168.2.150/static/images/index-bg.png"]
        adPage.webURL    = "https://www.sina.com.cn"
        
        var images: [String] = []
        for i in 0..<6 {
            images.append("IMG_07\(77 + i)")
        }
        adPage.imageNames = images
        
        return adPage
    }
    
    //    enum CodingKeys: String {
    //
    //    }
    
}

public class AdPageItem {
    
    // 本地图片名
    var imageNames: String?
    
    // 网络图片
    var imageURLs: String?
    
    // 跳转链接
    var webURL: String?
    
    // 视频链接
    var videoURL: String?
    
}
