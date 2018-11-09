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
    
    var pageItems: [AdPageItem]?
    
    // 时间间隔
    var timeInterval: Int = 3
    
    
    var localPath: String?
    
    // 测试用
    static func testPage(type: AdPageContentType = .singleImage) -> AdPage {
        
        let imageUrl = "http://192.168.2.150/static/images/index-bg.png"
        let webUrl   = "https://www.sina.com.cn"
        let videoUrl = Bundle.main.url(forResource: "keep", withExtension: "mp4")
        
        let adPage = AdPage()
        adPage.contentType = type
        
        var items = [AdPageItem]()
        for i in 0..<6 {
            
            let item = AdPageItem()
            item.imageName  = "IMG_07\(77 + i)"
            item.imageURL   = imageUrl
            item.webURL     = webUrl
            item.videoURL   = videoUrl
            
            items.append(item)
        }
        adPage.pageItems = items
        
        return adPage
    }
    
}

extension AdPage {
    
    func matched(webURL: String) -> AdPageItem?{
        
        return pageItems?.filter{  $0.webURL == webURL}.first
    }
    
    
}


public class AdPageItem: Codable {
    
    // 本地图片名
    var imageName: String?
    
    // 网络图片
    var imageURL: String?
    
    // 跳转链接
    var webURL: String?
    
    // 视频地址
    var videoURL: URL?
    
}
