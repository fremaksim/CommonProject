//
//  AppDelegate.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import Siren // for test Bundle ID  com.ruifu.technology.RuiFuBox ,origin Bundle ID com.mozheanquan.MohistPDFReader

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
        registerWeboSDK()
        
        //        setupSiren()
        
        threeDimensionalTouch(launchOptions)
        
        se7enForTest()
        
        return true
    }
    
    private func se7enForTest() {
        
        print("Points bounds: \(UIScreen.main.bounds)")
        print("Points scale: \(UIScreen.main.scale)")
        
        print("Pixels bounds: \(UIScreen.main.nativeBounds)")
        print("Pixels scale: \(UIScreen.main.nativeScale)")
        
        if UIScreen.main.scale != UIScreen.main.nativeScale {
            
        }
        
        
        
        /*  let class1 = Class(classId: "1", name: "Math")
         let mathTeacher = Teacher(name: "mm", age: 30, salary: 100)
         mathTeacher.title = "Species Teacher"
         class1.teacher = mathTeacher
         let student1 = Student(name: "ww", age: 11, id: "1")
         let student2 = Student(name: "zz", age: 11, id: "2")
         let student3 = Student(name: "yy", age: 11, id: "3")
         class1.students = [student1, student2, student3]
         
         let class1Dict = ModelJSON.convertToDictNesting(obj: class1)
         print(class1Dict)
         
         let class2 = Class(classId: "1", name: "Chinese")
         let chineseTeacher = Teacher(name: "ll", age: 35, salary: 100)
         class2.teacher = chineseTeacher
         class2.students = [student1, student2]
         let class2Dict = ModelJSON.convertToDictNesting(obj: class2)
         print(class2Dict)
         */
        
        let infomation = Info(id: "ioood")
        let deviceInfo = DeviceInfo(id: "i0do", model: "pdf")
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        if let infoData = try? encoder.encode(infomation) {
            if let newInfo = try? decoder.decode(Info.self, from: infoData) {
                log.info(newInfo.identifier)
            }
        }
        if let deviceData = try? encoder.encode(deviceInfo) {
            do{
                let newDevice = try decoder.decode(DeviceInfo.self, from: deviceData)
                log.info(newDevice.identifier)
                log.info(newDevice.model)
            }catch {
                log.error(error.localizedDescription)
            }
        }
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
        
        Siren.shared.checkVersion(checkType: .immediately)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        log.info("DidBecomeActive")
        
        Siren.shared.checkVersion(checkType: .immediately)
        
        threeDimensionalTouchAppBecomeActive()
        
        //        loadADWelcomePage()
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

//MARK: - 微博登录
extension AppDelegate: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        
    }
    
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        if response.isKind(of: WBAuthorizeResponse.self) {
            log.info(response)
            if let newResponse = response as? WBAuthorizeResponse {
                _ = newResponse.refreshToken
                let wbCurrentUserID = newResponse.userID
                guard let wbToken = newResponse.accessToken else {
                    return
                }
                
                //               log.info(wbToken)
                //                log.info(wbCurrentUserID)
                //                log.info(wbRefreshToken)
                WeiboLoginHandle.shared.getUserInfo(uid: wbCurrentUserID, accessToken: wbToken, screenName: nil) { (userInfo, error) in
                    
                }
                
            }
        }
    }
    
    func registerWeboSDK() {
        WeiboSDK.enableDebugMode(true)
        let id = ThirdParty(.weibo).appIdKey.id
        WeiboSDK.registerApp(id)
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
        
        if WeiboSDK.handleOpen(url, delegate: self) {
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
        if urlKey == ThirdParty(.weibo).sourceApplicationKey {
            // 微博 的回调
            return WeiboSDK.handleOpen(url, delegate: self)
        }
        
        return true
    }
    
}

//MARK: - Version Updte
extension AppDelegate: SirenDelegate {
    fileprivate  func setupSiren() {
        let siren = Siren.shared
        
        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = true
        
        // Optional - Change the name of your app. Useful if you have a long app name and want to display a shortened version in the update dialog (e.g., the UIAlertController).
        //        siren.appName = "Test App Name"
        
        // Optional - Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
        //        siren.alertMessaging = SirenAlertMessaging(updateTitle: NSAttributedString(string: "New Fancy Title"),
        //                                                   updateMessage: NSAttributedString(string: "New message goes here!"),
        //                                                   updateButtonMessage: NSAttributedString(string: "Update Now, Plz!?"),
        //                                                   nextTimeButtonMessage: NSAttributedString(string: "OK, next time it is!"),
        //                                                   skipVersionButtonMessage: NSAttributedString(string: "Please don't push skip, please don't!"))
        
        // Optional - Defaults to .Option
        //        siren.alertType = .option // or .force, .skip, .none
        
        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        
        // 这里加入后台API版本升级检查,更据条件设置级别
        
        siren.majorUpdateAlertType = .force
        siren.minorUpdateAlertType = .option
        siren.patchUpdateAlertType = .option
        siren.revisionUpdateAlertType = .option
        
        // Optional - Sets all messages to appear in Russian. Siren supports many other languages, not just English and Russian.
        //        siren.forceLanguageLocalization = .russian
        
        // Optional - Set this variable if your app is not available in the U.S. App Store. List of codes: https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html
        siren.countryCode = "cn"
        
        // Optional - Set this variable if you would only like to show an alert if your app has been available on the store for a few days.
        // This default value is set to 1 to avoid this issue: https://github.com/ArtSabintsev/Siren#words-of-caution
        // To show the update immediately after Apple has updated their JSON, set this value to 0. Not recommended due to aforementioned reason in https://github.com/ArtSabintsev/Siren#words-of-caution.
        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        
        // Optional (Only do this if you don't call checkVersion in didBecomeActive)
        //        siren.checkVersion(checkType: .immediately)
    }
    //MARK: - Siren Delegate Methods
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        print(#function, alertType)
    }
    
    func sirenUserDidCancel() {
        print(#function)
    }
    
    func sirenUserDidSkipVersion() {
        print(#function)
    }
    
    func sirenUserDidLaunchAppStore() {
        print(#function)
    }
    
    func sirenDidFailVersionCheck(error: Error) {
        print(#function, error)
    }
    
    func sirenLatestVersionInstalled() {
        print(#function, "Latest version of app is installed")
    }
    
    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel) {
        print(#function, "\(lookupModel)")
    }
    
    // This delegate method is only hit when alertType is initialized to .none
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: UpdateType) {
        print(#function, "\n\(title)\n\(message).\nRelease type: \(updateType.rawValue.capitalized)")
    }
}

//MARK: - AD、Welecome
extension AppDelegate {
    
    fileprivate func  loadADWelcomePage(){
        
        //get userdefaults lastest version
        
        //compare with current version
        
        //save version to lastest userdefaults
        
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
