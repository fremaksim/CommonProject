//
//  SmsViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/12.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

final class SmsViewModel {
    
    let phone: String
    
    let countTime: Int = 60 //60秒
    let codeCount: Int
    
    init(phone: String, codeCount: Int) {
        self.phone     = phone
        self.codeCount = codeCount
    }
    
    var title: String {
        return "输入短信验证码"
    }
    var backgroundColor: UIColor {
        return .white
    }
    
}
