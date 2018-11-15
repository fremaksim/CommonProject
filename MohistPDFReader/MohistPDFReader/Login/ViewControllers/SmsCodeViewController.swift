//
//  SmsCodeViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class SmsCodeViewController: UIViewController {
    
    let viewModel: SmsViewModel
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    init(viewModel: SmsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = viewModel.backgroundColor
        title = viewModel.title
        
        let rect =  CGRect(x: 20, y: 80, width: UIScreen.main.bounds.size.width - 40, height: 50)
        let codeView = MohistSMSVerificationCodeView(frame: rect)
        view.addSubview(codeView)
        codeView.keyboardType = .decimalPad
        codeView.codeCount = 6
        codeView.callback = {  str in
            print(str)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
}

