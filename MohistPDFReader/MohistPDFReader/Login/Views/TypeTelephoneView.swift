//
//  TypeTelephoneView.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import SnapKit

protocol TypeTelephoneViewDelegate: class {
    func didClickFetchSmsCode(phone: String)
}

class TypeTelephoneView: UIView {
    
    weak var delegate: TypeTelephoneViewDelegate?
    
    lazy var areaLabel: UILabel = {
        let label = UILabel()
        label.text = "中国大陆"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return label
    }()
    
    lazy var arrowImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var phoneTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = "输入手机号"
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.keyboardType = .decimalPad
        textField.delegate = self
        return textField
    }()
    
    lazy var fetchSmsCodeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("获取短信验证码", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.green.withAlphaComponent(0.6)
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(smsCodeButtonAction), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let margin: CGFloat = 20
        let height: CGFloat = 50
        let container = UIView()
        addSubview(container)
        container.snp.makeConstraints { (make) in
            make.leading.equalTo(margin)
            make.trailing.equalTo(-margin)
            make.height.equalTo(height)
            make.top.equalTo(0)
        }
        
        container.addSubview(areaLabel)
        //        container.addSubview(arrowImage)
        container.addSubview(phoneTextField)
        areaLabel.snp.makeConstraints { (make) in
            make.leading.top.bottom.equalTo(0)
            make.width.lessThanOrEqualTo(100)
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.leading.equalTo(areaLabel.snp.trailing)
            make.top.bottom.right.equalTo(0)
        }
        
        addSubview(fetchSmsCodeButton)
        fetchSmsCodeButton.layer.cornerRadius = 15
        fetchSmsCodeButton.layer.masksToBounds = true
        fetchSmsCodeButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(container)
            make.height.equalTo(30)
            make.top.equalTo(container.snp.bottom).offset(10)
        }
        showCodeButtonStyle(isEnable: false)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: --- Event Response
    @objc private func smsCodeButtonAction (){
        delegate?.didClickFetchSmsCode(phone: phoneTextField.text!)
    }
    
    
    private func showCodeButtonStyle(isEnable: Bool){
        fetchSmsCodeButton.isUserInteractionEnabled = isEnable
        fetchSmsCodeButton.alpha = isEnable ? 1.0 : 0.5
    }
    
}

extension TypeTelephoneView: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var newSring = textField.text
        if string.isBackspace() {
            let last =  newSring?.lastCharacterAsString
            if let lastStr = last, let newStr = newSring{
                newSring = newStr.removingSuffix(lastStr)
            }
        }else{
            newSring = (textField.text ?? "") + string
        }
        validPhoneMailand(string: newSring)
        return true
    }
    
    private func validPhoneMailand(string: String?){
        showCodeButtonStyle(isEnable: string?.count == 11)
    }
}
