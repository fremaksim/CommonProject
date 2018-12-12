//
//  AppDelegate.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let log = LogManager.shared.log
    var window: UIWindow?
    var coordinator: AppCoordinator!
    // qq 登录
    lazy var tencentAuth: TencentOAuth = {
        let auth = TencentOAuth(appId: ThirdParty(.qq).appIdKey.id, andDelegate: self)
        return auth!
    }()
    // 3D Touch (Only available in (iOS 9 and iPhone6s) +)
    private var launchedShortcutItem: UIApplicationShortcutItem?
    private  enum ShortcutIdentifier: String {
        case first
        case second
        
        init?(fullNameForType: String) {
            guard let last = fullNameForType.components(separatedBy: ".").last else { return nil }
            self.init(rawValue: last)
        }
        var type: String {
            return Bundle.main.bundleIdentifier! + "." + self.rawValue
        }
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator(window: window!)
        coordinator.start()
        
        registerWeiXinAPI()
        
        threeDimensionalTouch(launchOptions)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        log.info("WillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        log.info("DidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        log.info("WillEnterForeground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        log.info("DidBecomeActive")
        
        threeDimensionalTouchAppBecomeActive()
        
        loadADWelcomePage()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

//MARK: --- QQ 登录
extension AppDelegate: TencentSessionDelegate {
    func tencentDidLogin() {
        // 登录成功后要调用一下这个方法, 才能获取到个人信息
        tencentAuth.getUserInfo()
    }
    
    func tencentDidNotLogin(_ cancelled: Bool) {
        log.warning(cancelled)
    }
    
    func tencentDidNotNetWork() {
        log.error("网络异常")
    }
    
    func getUserInfoResponse(_ response: APIResponse!) {
        // 获取个人信息
        guard   response.retCode == 0,
            let res = response.jsonResponse else {
                return
        }
        
        if let _ = self.tencentAuth.getUserOpenID() {
            // 获取uid
        }
        
        if let _ = res["nickname"] {
            // 获取nickname
        }
        
        if let _ = res["gender"] {
            // 获取性别
        }
        
        if let _ = res["figureurl_qq_2"] {
            // 获取头像
        }
        log.debug(res)
        
    }
}

//MARK: --- 微信登录
extension AppDelegate: WXApiDelegate {
    func registerWeiXinAPI() {
        WXApi.registerApp(ThirdParty(.wechat).appIdKey.id)
    }
    
    func onReq(_ req: BaseReq!) {
        
    }
    
    func onResp(_ resp: BaseResp!) {
        
        WechatLoginHandle.shared.response(resp) { (userInfo, error) in
            if let userInfo = userInfo {
                self.log.info(userInfo)
            }else{
                guard let error = error else { return }
                self.log.error(error.localizedDescription)
            }
        }
    }
}

//MARK: --- 处理第三方 回调
extension AppDelegate {
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        if TencentOAuth.canHandleOpen(url) {
            return TencentOAuth.handleOpen(url)
        }
        
        if WXApi.handleOpen(url, delegate: self) {
            return true
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let urlKey: String = options[.sourceApplication] as! String
        
        if urlKey == ThirdParty(.qq).sourceApplicationKey {
            // QQ 的回调
            return  TencentOAuth.handleOpen(url)
        }
        if urlKey == ThirdParty(.wechat).sourceApplicationKey {
            // 微信 的回调
            return  WXApi.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
}

//MARK: - AD、Welecome
extension AppDelegate {
    
    fileprivate func  loadADWelcomePage(){
        let isShow = true
        if isShow {
            guard let rootVC = window?.rootViewController as? NavigationController else { return }
            let naviVC = rootVC.childNavigationController.topViewController
            
            let page = AdPage.testPage()
            page.contentType = .singleImage
            let adVC = ADPageWelcomeViewController(viewModel: ADPageViewWelcomeViewModel(guideType: .ad, page: page )) { [weak rootVC] (str) in
                let adWeb = AdWeb(url: str)
                let webViewModel = AdWebViewModel(adWeb: adWeb)
                let webViewController = AdWebViewController(viewModel: webViewModel)
                
                rootVC?.childNavigationController.pushViewController(webViewController, animated: true)
            }
            naviVC?.addChild(adVC)
            naviVC?.view.addSubview(adVC.view)
        }
    }
}

//MARK: --- 3D Touch
extension AppDelegate {
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(handleShortcut(shortcutItem))
    }
    
    
    /// 3D Touch
    ///
    /// - Parameter launchOptions: launchOptions
    private func threeDimensionalTouch(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            launchedShortcutItem = shortcutItem
        }
    }
    
    private func threeDimensionalTouchAppBecomeActive() {
        guard let shortcutItem = launchedShortcutItem else {
            return
        }
        _ = handleShortcut(shortcutItem)
        
        // We make it nil after perfom/handle method call for that shortcutItem action
        launchedShortcutItem = nil
    }
    
    
    private func handleShortcut(_ item: UIApplicationShortcutItem) -> Bool {
        var handle = false
        
        // Verify that the provided shortcutItem's type is one handled by the application.
        guard ShortcutIdentifier(fullNameForType: item.type) != nil  else { return false }
        guard let shortcutType = item.type as String? else { return false }
        
        switch shortcutType {
        case ShortcutIdentifier.first.type: //Login
            print(shortcutType) //跳转到相应的VC
            handle = true
        case ShortcutIdentifier.second.type: //
            print(shortcutType) //跳转到相应的VC
            handle = true
        default:
            handle = false
        }
        
        return handle
        
    }
    
}
