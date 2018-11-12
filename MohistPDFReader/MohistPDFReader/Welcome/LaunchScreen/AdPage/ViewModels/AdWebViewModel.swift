//
//  AdWebViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import Foundation

final class AdWebViewModel {
    
    let adWeb: AdWeb
    
    var url: String? {
        return adWeb.url
    }
    
    init(adWeb: AdWeb) {
        self.adWeb = adWeb
    }
    
}
