//
//  SignInSignupViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit


class SignInSignupViewController: UIViewController {
    
    //MARK: --- Life Cycle
    private let viewModel: LoginViewModel
    
    lazy var telephoneView: TypeTelephoneView = {
        let view = TypeTelephoneView()
        view.delegate = self
        return view
    }()
    
    lazy var thirdLoginView: ThirdLoginView = {
        let thirdView = ThirdLoginView()
        thirdView.delegate = self
        return thirdView
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        title = "手机号码登录"
        
        loadViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let codes = TelephoneNationalCode.fromJSONFile() {
            for code in codes {
                print(code)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: --- Private  Methods
    
    private func loadViews(){
        view.addSubview(telephoneView)
        telephoneView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(88)
            make.height.equalTo(120)
        }
        
        view.addSubview(thirdLoginView)
        thirdLoginView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(-70)
            make.height.equalTo(100)
        }
    }
    
    fileprivate func viewResignFirstResponse(){
        view.endEditing(true)
    }
}

extension SignInSignupViewController: TypeTelephoneViewDelegate {
    func didClickFetchSmsCode(phone: String) {
        
        viewResignFirstResponse()
        
        let title = "发送短信给: " + phone
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "发送", style: .default) { [weak self](_) in
            let vc = SmsCodeViewController(phone: phone)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SignInSignupViewController: ThirdLoginViewProtocol {
    func didClickItem(name: String) {
        
        viewResignFirstResponse()
        
        let title = "选择 " + name + "  登录？"
        
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .default) { [weak self](_) in
            let vc = ScanQRCodeLoginViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
