//
//  SignInSignupViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/9.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import Atributika

protocol SignInSignUpViewControllerDelegate: class {
    func didClickVerificationCode(with phone: String)
}

class SignInSignupViewController: UIViewController {
    
    weak var delegate: SignInSignUpViewControllerDelegate?
    
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
    
    //MARK: --- Life Cycle
    init(viewModel: LoginViewModel) {
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
        
        let clickableLabel = AttributedLabel()
        clickableLabel.numberOfLines = 2
        clickableLabel.textAlignment = .center
        
        let clickableText = """
 同意<a>中国移动认证服务协议</a>
 登录即代表您同意<b>用户协议</b>和<c>隐私政策</c>
 """
        let all = Style.font(.systemFont(ofSize: 13)).foregroundColor(.black)
        let linkA = Style("a").foregroundColor(.blue, .normal)
            .foregroundColor(.green, .highlighted)
        let linkB = Style("b").foregroundColor(.blue, .normal)
            .foregroundColor(.green, .highlighted)
        let linkC = Style("c").foregroundColor(.blue, .normal)
            .foregroundColor(.green, .highlighted)
        clickableLabel.attributedText = clickableText.style(tags: [linkA,linkB,linkC]).styleAll(all)
        
        clickableLabel.onClick = { label, detection in
            switch detection.type {
            case .tag(let tag):
                if tag.name == "a" {
                    UIApplication.shared.open(URL(string: "https://www.baidu.com")!, options: [:], completionHandler: nil)
                }else if tag.name == "b"{
                    UIApplication.shared.open(URL(string: "https://www.sina.com.cn")!, options: [:], completionHandler: nil)
                }else if tag.name == "c"{
                    UIApplication.shared.open(URL(string: "https://www.hao123.com")!, options: [:], completionHandler: nil)
                }
            default:
                break
            }
            
        }
        clickableLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clickableLabel)
        clickableLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
            make.top.equalTo(thirdLoginView.snp.bottom).offset(4)
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
            self?.delegate?.didClickVerificationCode(with: phone)
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
            if name == "扫码" {
                let vc = ScanQRCodeLoginViewController()
                self?.navigationController?.pushViewController(vc, animated: true)
            }else if name == "QQ"{
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                let permissions = [kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]
                appDelegate.tencentAuth.authorize(permissions)
            }else if name == "微信" {
                WechatLoginHandle.shared.sendWechatAuth(completion: { (userInfo, error) in
                    guard let userInfo = userInfo else {
                        if let error = error {
                            LogManager.shared.log.error(error.localizedDescription)
                        }
                        return
                    }
                    LogManager.shared.log.info(userInfo)
                })
            }
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
