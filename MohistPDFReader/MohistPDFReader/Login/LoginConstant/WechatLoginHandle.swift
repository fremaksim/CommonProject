//
//  WechatLoginHandle.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

private let log = LogManager.shared.log
private let appId = ThirdParty(.wechat).appIdKey.id
private let appSecret = ThirdParty(.wechat).appIdKey.key

//TODO: -- 不应该采用单例 常驻内存
final class WechatLoginHandle: NSObject {
    static let shared = WechatLoginHandle(toObserve: WechatLoginHandleToObserve())
    
    @objc var userInfoToObserve: WechatLoginHandleToObserve
    var observation: NSKeyValueObservation?
    init(toObserve: WechatLoginHandleToObserve) {
        self.userInfoToObserve = toObserve
        super.init()
    }
    
    /// 授权登录第一步。发起请求微信OAuth2.0授权登录-> 拉起微信 -> 用户确认登录第三方应用 -> 返回授权临时票据（code）
    /// -> 拉起第三方应用或者重定向到第三方app
    /// -> 进入第二步
    /// - Parameter completion: 最终微信用户信息
    func  sendWechatAuth(completion: @escaping(([String: Any]?, Error?) -> Void)){
        //如果有 accessToken 则刷新 accessToken
        // 否则 请求
        if let accessTokenDict = LoginStorage.getAccessTokenDict(),
            let accessToken = accessTokenDict[PreferenceOption.wechatAccessToken.key] as? String {
            refreshAccessToken(refreshAccessToken: accessToken) { (dic, error) in
                completion(dic,error)
            }
        }else{
            let seq = SendAuthReq()
            seq.scope = "snsapi_userinfo"
            seq.state = String(Int.random(in: 0...1000))
            WXApi.send(seq)
            observation = observe(\.userInfoToObserve.userInfo,options: [.old, .new]){ (objcet, change) in
                //                log.info(change.newValue)
                completion(change.newValue, nil)
            }
        }
    }
    
    ///
    ///  异步子线程处理请求，主线程处理请求
    /// - Parameters:
    ///   - resp: WXApi resp
    ///   - completion: userInfo or error
    func response(_ resp: BaseResp,completion: @escaping(([String: Any]?, Error?) -> Void)) {
        
        guard let sendRes = resp as? SendAuthResp,
            sendRes.errCode == 0 else {
                log.error(resp)
                return
        }
        let queue = DispatchQueue(label: "wechatLoginQueue")
        queue.async {
            // 第二步: 获取到code, 根据code去请求accessToken
            self.requestAccessToken(sendRes.code, completion: { (dict, error) in
                completion(dict,error)
            })
        }
    }
    
    
    /// 授权登录第二步。通过临时票据code和appid，appsecret 换取accessToken
    /// 得到 access token -> 进入第三步
    /// - Parameters:
    ///   - code: 临时票据
    ///   - completion: 最终用户信息 回调
    private   func requestAccessToken(_ code: String, completion: @escaping(([String: Any]?, Error?) -> Void)) { // 异步子线程
        // 第二步: 请求accessToken
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(appId)&secret=\(appSecret)&code=\(code)&grant_type=authorization_code"
        
        guard let url = URL(string: urlStr) else { return }
        
        do {
            //            log.verbose(Thread.current)
            
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            let responseData = try Data(contentsOf: url, options: .alwaysMapped)
            
            guard let dic = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                return
            }
            log.verbose(dic)
            /*
             ["expires_in": 7200, "access_token": 15_aFqQyEfxAYFoFYq-hOHMY4I46l1Up4loukV08yxJsw5XV8O9qF9Cl3HHm8lyVgnh5EAkgJToi-g2BPXR09U9McspnjxSB-4IZv-4H9WCG9s, "refresh_token": 15_RwMdMpXXRtN5mA3GFMQkIQI5vIk9JR_OuTr_Iqt8bbT1sCnhp2Md1CQrYQ4uNfeVLBFAyhlCA00M10s4io0lNGhqsfNYJAb8ZSKnIi_5MS0, "openid": oMTHxw8vHlGaqnsK-gN9tijvrCdE, "scope": snsapi_userinfo, "unionid": oiKU609xgcz0DleWL3lVaRV7WUXU]
             */
            
            saveAccessTokenDictRequestUserInfo(accessTokenDict: dic) { (dict, error) in
                completion(dict,error)
            }
            
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
                log.error(error.localizedDescription)
            }
        }
    }
    
    /// 辅助方法，本地保存用户 access token
    ///
    /// - Parameters:
    ///   - accessTokenDict: access token 字典
    ///   - completion: 最终用户信息回调
    private  func saveAccessTokenDictRequestUserInfo(accessTokenDict: [String: Any] ,completion: @escaping(([String: Any]?, Error?) -> Void)){
        
        // 存储 信息 // 设置定时 2小时 ，过期自动清除
        LoginStorage.saveAccessTokenDict(accessTokenDict)
        
        guard let accessToken = accessTokenDict["access_token"] as? String else {
            return
        }
        guard let openId = accessTokenDict["openid"] as? String else {
            return
        }
        // 根据获取到的accessToken来请求用户信息
        requestUserInfo(accessToken, openID: openId) { (dict, error) in
            completion(dict,error)
        }
    }
    
    /// 授权登录第三步(最后一步)。通过accessToken 和 openid 获取用户基本信息
    ///
    /// - Parameters:
    ///   - accessToken: access token
    ///   - openID: openid
    ///   - completion: 最终用户信息回调
    private  func requestUserInfo(_ accessToken: String, openID: String, completion: @escaping(([String: Any]?, Error?) -> Void)) {
        
        let urlStr = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openID)"
        
        guard let url = URL(string: urlStr) else { return }
        
        do {
            //                    let responseStr = try String.init(contentsOf: url!, encoding: String.Encoding.utf8)
            let responseData = try Data(contentsOf: url, options: .alwaysMapped)
            guard let dic = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                DispatchQueue.main.async{
                    //TODO: -- 应该传一个 Error
                    completion(nil,nil)
                }
                return
            }
            // 这个字典(dic)内包含了我们所请求回的相关用户信息
            DispatchQueue.main.async {
                self.userInfoToObserve.userInfo = dic
                completion(dic,nil)
            }
            
        } catch {
            DispatchQueue.main.async {
                // 获取授权信息异常
                completion(nil,error)
            }
        }
    }
    
    /// 根据refreshToken 刷新 accessToken 有效期（2小时）
    ///
    /// - Parameters:
    ///   - refreshAccessToken: refresh Token
    ///   - completion: 最终UserInfo 回调
    private  func refreshAccessToken(refreshAccessToken: String,completion: @escaping(([String: Any]?, Error?) -> Void)) {
        guard let refreshToken = LoginStorage.getRefreshToken() else { return }
        let urlStr = "https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=\(appId)&grant_type=refresh_token&refresh_token=\(refreshToken)"
        guard let url = URL(string: urlStr) else { return }
        do {
            let responseData = try Data(contentsOf: url, options: .alwaysMapped)
            guard let dic = try JSONSerialization.jsonObject(with: responseData, options: .allowFragments) as? [String: Any] else {
                return
            }
            saveAccessTokenDictRequestUserInfo(accessTokenDict: dic) { (dict, error) in
                completion(dict,error)
            }
        } catch {
            DispatchQueue.main.async {
                completion(nil,nil)
            }
        }
    }
}


// for 键值观察
final class WechatLoginHandleToObserve: NSObject {
    @objc dynamic var userInfo: [String: Any] = [:]
    
}
