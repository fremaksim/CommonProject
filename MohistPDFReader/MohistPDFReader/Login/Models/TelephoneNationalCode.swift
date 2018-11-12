//
//  TelephoneNationalCode.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class TelephoneNationalCode: Codable, CustomStringConvertible {
    
    var code: String
    var nation: String
    
    init(code: String, nation: String) {
        self.code = code
        self.nation = nation
    }
    
    var description: String {
        return "{code: \(code), nation: \(nation)}"
    }
    
    static func fromJSONFile() -> [TelephoneNationalCode]? {
        
        guard let path = Bundle.main.url(forResource: "TelephoneNationalCode", withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: path)
            guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: Any] else { return nil }
            guard let dict = json["data"] as? [String: String] else { return nil }
            return  instanceFrom(dict: dict)
        }catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    static func instanceFrom(dict: [String: String]) -> [TelephoneNationalCode] {
        let allKeys = dict.keys
        var codes: [TelephoneNationalCode] = []
        for key in allKeys {
            if let value = dict[key] {
                let instance = TelephoneNationalCode(code: key, nation: value)
                codes.append(instance)
            }
        }
        return codes
    }
}
