//
//  ADPageViewWelcomeViewModel.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

public enum GuideType {
    case ad, welcome
}

public class ADPageViewWelcomeViewModel {
    
    public let guideType: GuideType
    
    public let contentType: AdPageContentType

    init(guideType: GuideType, contenType: AdPageContentType) {
        self.guideType   = guideType
        self.contentType = contenType
    }
    
    
    
    
}
