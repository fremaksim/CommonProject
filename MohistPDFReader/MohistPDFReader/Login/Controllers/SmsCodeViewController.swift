//
//  SmsCodeViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class SmsCodeViewController: UIViewController {
    
    let phone: String
    //    private let baseTag: Int = 10086
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    
    init(phone: String) {
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        title = "输入短信验证码"
        
        let codeview = SMSCodeView()
        view.addSubview(codeview)
        codeview.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(100)
            make.height.equalTo(40)
        }
    }
    
    deinit {
        
    }
}



extension SmsCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 前一个有数子，后一个才能成为第一响应者， 其余都不能。 只能响应后退键，（后退键 ，前一个文字删除，成为第一响应者）
        
        if textField.text?.count == 1 && !string.isBackspace() {
            return false
        }
        
        if let codeTextField = textField as? CodeTextField {
            var currentTag = codeTextField.tag
            while currentTag > CodeTextField.baseTag {
                let preTag = currentTag - 1
                currentTag -= 1
                if let text = view.viewWithTag(preTag) as? CodeTextField, text.hasText, !textField.hasText {
                    return true
                }
                return false
            }
        }
        
        return true
    }
    
}
