//
//  ProfileViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation
import UIKit


enum ProfileConten: String, CaseIterable{
    case about, login, logout
    var type: String {
        switch self {
        case .about:
            return "关于"
        case .login:
            return "登录\\注册"
        case .logout:
            return "退出登录"
        }
    }
}


final class ProfileViewModel: NSObject {
    
    var title: String {
        return "我的"
    }
    
    var backgroundColor: UIColor {
        return .white
    }
    
    var contents:[ProfileConten] {
        return ProfileConten.allCases
    }
    
}
