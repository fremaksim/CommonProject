//
//  DiscoveryViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        let rect =  CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 50)
        let codeView = MohistSMSVerificationCodeView(frame: rect)
        view.addSubview(codeView)
//        codeView.snp.makeConstraints { (make) in
//
//            make.left.equalTo(20)
//            make.right.equalTo(-20)
//            make.top.equalTo(80)
//            make.height.equalTo(50)
//        }
        codeView.keyboardType = .decimalPad
        codeView.codeCount = 6
        codeView.callback = {  str in
            print(str)
        }
        
        
    }
    
}
