//
//  StringExtension.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

extension String {
    
    func isBackspace() -> Bool {
        let  char = self.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            return true
        }
        return false
    }
}
