//
//  Storage.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

//
enum MoStorageType{
    case preferences
    case fileArchive
    case database
    case keychain
}
// key protocol
//
protocol MoStorageProtocol {}
protocol MoStrorageCommonProtocol: MoStorageProtocol {
  func save(type: MoStorageType, value: Any, key: String)
  func getValue(type: MoStorageType,for key: String) -> Any?
  func remove(type: MoStorageType,for key: String)
}





// 存储类
final class MoStorage: MoStrorageCommonProtocol {

    static let shared = MoStorage()
    let preferencesController = PreferencesController()
    
    func save(type: MoStorageType, value: Any, key: String) {
        switch type {
        case .preferences:
            preferencesController.set(value: value, for: key)
        default:
            let _ = MoStorage()
        }
    }
    func remove(type: MoStorageType, for key: String) {
        switch type {
        case .preferences:
            preferencesController.remove(for: key)
        default:
            let _ = MoStorage()
        }
    }
    
    func getValue(type: MoStorageType, for key: String) -> Any? {
        switch type {
        case .preferences:
          return  preferencesController.getValue(for: key)
        default:
            let _ = MoStorage()
            return nil
        }
    }
    
    
    
}
