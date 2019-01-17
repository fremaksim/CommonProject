//
//  AppHelper.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/12/17.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

public struct AppHelper {
    
    // Targets -> General: Version
    static func version() -> String? {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    // Targets -> General: Build
    static func buildVersion() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
    
    // Version + (format) + Build
    static func fullVersion() -> String? {
        if let v = version() {
            if let b = buildVersion() {
                return v + "(\(b))"
            }else {
                return v
            }
        }
        return nil
    }
    
}
