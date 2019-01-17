//
//  ThirdParty.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

typealias AppIdKey = (id: String, key: String)

enum ThirdPlatform: String {
    case qq      = "QQ"
    case wechat  = "微信"
    case weibo   = "微博"
    case phone   = "手机号"
    case scan    = "扫码"
    case empty   = ""
}


struct ThirdParty {
    let platform: ThirdPlatform
    
    let userDefault: UserDefaults = UserDefaults.standard
    
    init(_ platform: ThirdPlatform) {
        self.platform = platform
    }
    
    var sourceApplicationKey: String {
        switch platform {
        case .qq:
            return "com.tencent.mqq"
        case .wechat:
            return "com.tencent.xin"
        case .weibo:
            return "com.sina.weibo"
        default:
            return ""
        }
    }
    var appIdKey: AppIdKey {
        switch platform {
        case .qq:
            return AppIdKey(id: "1107965692", key: "A08deA8BHsyvD1SE")
        case .wechat:
            //ruifu
            //            return AppIdKey(id: "wx7d2b1672d57ca451", key: "1013ad5f9cfd41df44fdc99e04427b35")
            
            return AppIdKey(id: "wxe2fdc6f870742841", key: "40cefef763e87496ec08def578c1d6bb")
        case .weibo:
            // app key == id , app secrect == key
            return AppIdKey(id: "2430314318" ,key: "93bae70f61dacb408a875b60f8e1a755")
        default:
            return AppIdKey(id: "", key: "")
        }
    }
    
    
    enum ThirdPlatformSubType {
        case pay            //支付
        case share          //分享
        case authorLogin    //登录
    }
    
}


