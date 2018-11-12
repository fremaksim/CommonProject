
//
//  LoginViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit


public enum LogingType {
    case phone,wechat,qq,qrcode
    
    static func allcase() -> [LogingType] {
        return [.phone, .wechat,.qq,.qrcode]
    }
    
}

final class LoginViewModel {
    
    var localPhoneNumber: String? {
        return "+86 135***5230"
    }
    
    let loginTypes: [LogingType] = LogingType.allcase()
    
    
}

