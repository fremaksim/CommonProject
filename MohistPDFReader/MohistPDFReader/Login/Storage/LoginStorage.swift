//
//  LoginStorage.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

final class LoginStorage {
    
    static var expire: Int = 7200
    
    static var didSavedAccessToken: Bool = false
    
    static func saveAccessTokenDict(_ dict: Any) {
        Storage.shared.save(type: .preferences, value: dict, key: PreferenceOption.wechatAccessTokenDictionary.key)
        setTimerForAccessToken()
        didSavedAccessToken = true
    }
    static func getRefreshToken() -> String? {
        let dict = Storage.shared.preferencesController.getValue(for: .wechatAccessTokenDictionary) as? [String: Any]
        return dict?[PreferenceOption.wechatRefreshToken.key] as? String
    }
    static func getAccessTokenDict() -> [String: Any]? {
        return Storage.shared.getValue(type: .preferences, for: PreferenceOption.wechatAccessTokenDictionary.key) as? [String: Any]
    }
    
    static private func setTimerForAccessToken(){
        let preferencesController = Storage.shared.preferencesController
        let dict = preferencesController.getValue(for: .wechatAccessTokenDictionary) as? [String: Any]
        guard let expire = dict?[PreferenceOption.wechatAuthExpires.key] as? Int else {
            return
        }
        LogManager.shared.log.debug(expire)
        self.expire = expire
        
        DispatchQueue.main.async { // 设置定时器 自动移除过期 accessToken
            let timer = Timer(timeInterval: 1, target: self, selector: #selector(removeAccessTokenDict), userInfo: nil, repeats: true)
            preferencesController.timer = timer
            RunLoop.current.add(timer, forMode: .common)
        }
        
    }
    
    @objc static private func removeAccessTokenDict(){
        expire =  expire - 1
        if expire == 0 {
            let preferencesController = Storage.shared.preferencesController
            preferencesController.remove(for: PreferenceOption.wechatAccessTokenDictionary.key)
            preferencesController.timer?.invalidate()
            preferencesController.timer = nil
            didSavedAccessToken = false
        }
    }
}
