//
//  TableViewCellExtension.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/16.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    
    public static func cellIdentifier() -> String {
        return String(describing: self)
    }
    
}
