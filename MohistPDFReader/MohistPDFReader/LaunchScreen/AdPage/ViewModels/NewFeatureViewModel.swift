//
//  NewFeatureViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/8.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

public class NewFeatureViewModel {
    
    var images:    [UIImage]?
    var imageUrls: [String]?
    
    var imageCount: Int {
        
        if let count = images?.count {
            return count
        }else if let count = imageUrls?.count {
            return count
        }else{
            return 0
        }
        
    }
    
    init(images: [UIImage]?, imageUrls: [String]? = nil) {
        self.images    = images
        self.imageUrls = imageUrls
        
    }
    
    
}
