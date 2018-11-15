//
//  PerferenceController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

final class PreferencesController: MoStorageProtocol {
    
    let userDefaults: UserDefaults
    
    var timer: Timer?
    
    //    let timer: Timer = Timer
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func set(value: Any, for option: String) {
        userDefaults.set(value, forKey: option)
        userDefaults.synchronize()
    }
    func getValue(for option: String) -> Any? {
        return  userDefaults.value(forKey: option)
    }
    
    func set(value: Any ,for option: PreferenceOption){
        userDefaults.setValue(value, forKey: option.key)
        userDefaults.synchronize()
    }
    
    func getValue(for option: PreferenceOption) -> Any? {
        return userDefaults.value(forKey: option.key)
    }
    
    //移除
    func remove(for option: String) {
        userDefaults.removeObject(forKey: option)
    }
    
}

enum PreferenceOption {
    
    case wechatAccessToken
    case wechatRefreshToken
    case wechatAuthExpires
    case wechatOpenId
    case wechatAccessTokenDictionary
    
    var key: String {
        switch self {
        case .wechatAccessToken:
            return "access_token"
        case .wechatRefreshToken:
            return "refresh_token"
        case .wechatAuthExpires:
            return "expires_in"
        case .wechatAccessTokenDictionary:
            return "WechatAccessTokenDictionary"
        case .wechatOpenId:
            return "openid"
        }
    }
    
}
