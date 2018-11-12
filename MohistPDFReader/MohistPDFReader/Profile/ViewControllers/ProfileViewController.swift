//
//  ProfileViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    fileprivate var viewModel: ProfileViewModel

    private lazy var loginButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("登录\\注册", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        btn.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        return btn
    }()
    
    //MARK: --- Life Cycle
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
        
    }
    
    //MARK: --- Events Response
    @objc private func loginButtonAction(){
        
    }
    
    
}
