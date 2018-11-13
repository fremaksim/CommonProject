
//
//  LoginViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit


public enum LogingType {
    case phone,wechat,qq,qrcode,weibo
    
    static func allcase() -> [LogingType] {
        return [.phone, .wechat,.qq,.qrcode]
    }
    var description: String {
        switch self {
        case .phone:
            return "手机号"
        case .wechat:
            return "微信"
        case .qq:
            return "QQ"
        case .qrcode:
            return "扫码"
        case .weibo:
            return "微博"
        }
    }
    
}

final class LoginViewModel {
    
    var loginTypes: [LogingType] = LogingType.allcase()
    
    var localPhoneNumber: String? {
        return "+86 135***5230"
    }
    
    var backgroundColor: UIColor {
        return .white
    }
    var title: String {
        return "手机号码登录"
    }
}

