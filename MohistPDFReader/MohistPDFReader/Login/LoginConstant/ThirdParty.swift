//
//  ThirdParty.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

typealias AppIdKey = (id: String, key: String)

enum ThirdPlatform {
    case qq
    case wechat
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
        }
    }
    var appIdKey: AppIdKey {
        switch platform {
        case .qq:
            return AppIdKey(id: "1107965692", key: "A08deA8BHsyvD1SE")
        case .wechat:
            return AppIdKey(id: "wx7d2b1672d57ca451", key: "1013ad5f9cfd41df44fdc99e04427b35")
        }
    }
  
    
}


