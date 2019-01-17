//
//  WeiboLoginHandle.swift
//  MohistPDFReader
//
//  Created by mozhe on 2019/1/2.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

private let log = LogManager.shared.log

class WeiboLoginHandle: NSObject {
    
    static let shared = WeiboLoginHandle(toObserve: WeiBoLoginHandleToObserve())

    @objc var userInfoToObserve: WeiBoLoginHandleToObserve
    var observation: NSKeyValueObservation?
    
    init(toObserve: WeiBoLoginHandleToObserve) {
        self.userInfoToObserve = toObserve
        super.init()
    }
    
    /// 微博请求用户授权
    ///
    /// - Parameters:
    ///   - requestInfo: 请求授权 参数
    ///   - completion: 完成回调 （用户信息， 错误）
    func sendWeiboOauth(requestInfo: [String: Any], completion: @escaping(([String: Any]?, Error?) -> Void )) {
        let request = WBAuthorizeRequest.request() as! WBAuthorizeRequest
        request.redirectURI = "https://www.sina.com"
        request.scope = "all"
        request.userInfo = /*["SSO_From": "SignInSignupViewController"]*/ requestInfo
        
        if  WeiboSDK.send(request) {
            observation = observe(\.userInfoToObserve.userInfo,options: [.old, .new]){ (objcet, change) in
                //                log.info(change.newValue)
                completion(change.newValue, nil)
            }
        }else {
            LogManager.shared.log.info("weibo error")
        }
    }
    
    
    /// according accessToken get User info
    ///
    /// - Parameters:
    ///   - uid: user id (optional)
    ///   - accessToken: accessToken (required)
    ///   - screenName: 昵称（optional）
    ///   - completion: user info key-value dict
    func getUserInfo(uid: String? = nil,
                     accessToken: String,
                     screenName: String? = nil,
                     completion: @escaping(([String: Any]?, Error?) -> () ))  {
        var urlStr = "https://api.weibo.com/2/users/show.json?access_token=\(accessToken)"
        if let uid = uid {
            urlStr.append("&uid=\(uid.urlEncoded)")
        }
        if let screenName = screenName {
            urlStr.append("$screen_name=\(screenName.urlEncoded)")
        }
        // 不能整个url urlEncoded， 可以单个参数urlEncoded
        //        let safeUrlStr =  urlStr.urlEncoded
        if let userInfoURL = URL(string: urlStr) {
            do {
                let responseData = try Data(contentsOf: userInfoURL, options: .alwaysMapped)
                
                guard let dic = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                    return
                }
                userInfoToObserve.userInfo = dic
                log.verbose(dic)
            }catch {
                log.error(error)
            }
            
        }else{
            completion(nil, NSError(domain: "微博获取用户信息接口URL格式错误", code: 0, userInfo: ["URL" : urlStr]))
        }
        
    }
}

// for 键值观察
final class WeiBoLoginHandleToObserve: NSObject {
    @objc dynamic var userInfo: [String: Any] = [:]
    
}

