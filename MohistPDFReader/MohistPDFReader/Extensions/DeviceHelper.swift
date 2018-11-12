//
//  SnapKit.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/12.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

public class DeviceHelper {
    
    public  static func isPhoneXorPhoneXS() -> Bool{
        
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2436 {
                return true
            }
        }
        return false
    }
    
    public static func isPhoneXSMax() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 2688 {
                return true
            }
        }
        return false
    }
    
    public static func isPhoneXR() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height == 1792 {
                return true
            }
        }
        return false
    }
    
    /// 是否是iPhone X 系列, include iPhone X ,  iPhone XS ,  iPhone XR,  iPhone XS Max.
    ///
    /// - Returns: true or false
    public static func isPhoneXSeries() -> Bool {
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return false
        }
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window,
                let mainWindow = window,mainWindow.safeAreaInsets.bottom > 0.0{
                return true
            }
            return false
        } else {
            // Fallback on earlier versions
            return false
        }
    }
    
    public static var navigationBarMaxY: CGFloat {
        if isPhoneXSeries() {
            return 88
        }else{
            return 64
        }
    }
    
    public static var tabBarYDistanceBottom: CGFloat {
        if isPhoneXSeries() {
            return  83
        }else{
            return 48
        }
    }
    
    
}
