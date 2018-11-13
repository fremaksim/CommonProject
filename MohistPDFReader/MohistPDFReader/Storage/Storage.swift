//
//  Storage.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/13.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

//
enum StorageType{
    case preferences
    case fileArchive
    case database
    case keychain
}
// key protocol
//
protocol StorageProtocol {}
protocol StrorageCommonProtocol: StorageProtocol {
  func save(type: StorageType, value: Any, key: String)
  func getValue(type: StorageType,for key: String) -> Any?
  func remove(type: StorageType,for key: String)
}





// 存储类
final class Storage: StrorageCommonProtocol {

    static let shared = Storage()
    let preferencesController = PreferencesController()
    
    func save(type: StorageType, value: Any, key: String) {
        switch type {
        case .preferences:
            preferencesController.set(value: value, for: key)
        default:
            let _ = Storage()
        }
    }
    func remove(type: StorageType, for key: String) {
        switch type {
        case .preferences:
            preferencesController.remove(for: key)
        default:
            let _ = Storage()
        }
    }
    
    func getValue(type: StorageType, for key: String) -> Any? {
        switch type {
        case .preferences:
          return  preferencesController.getValue(for: key)
        default:
            let _ = Storage()
            return nil
        }
    }
    
    
    
}
