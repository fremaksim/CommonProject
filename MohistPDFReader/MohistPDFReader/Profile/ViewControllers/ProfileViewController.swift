//
//  ProfileViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

private let kCellID = "cell"
protocol ProfileViewControllerDelegate: class {
    func didClickLoginButton()
    func didClickLogoutButton()
    func didClickAboutButton()
}

class ProfileViewController: UIViewController {
    
    fileprivate var viewModel: ProfileViewModel
    weak var delegate: ProfileViewControllerDelegate?
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellID)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    //    private lazy var loginButton: UIButton = {
    //        let btn = UIButton(type: .custom)
    //        btn.setTitle("登录\\注册", for: .normal)
    //        btn.setTitleColor(.white, for: .normal)
    //        btn.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    //        btn.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
    //        return btn
    //    }()
    
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
        
        //        view.addSubview(loginButton)
        //        loginButton.snp.makeConstraints { (make) in
        //            make.left.equalTo(0)
        //            make.top.equalTo(view.snp.top).offset(DeviceHelper.navigationBarMaxY)
        //            make.size.equalTo(CGSize(width: 80, height: 30))
        //        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(DeviceHelper.navigationBarMaxY)
        }
    }
    
    //MARK: --- Events Response
    @objc private func loginButtonAction(){
        delegate?.didClickLoginButton()
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellID, for: indexPath) as UITableViewCell
        let content = viewModel.contents[indexPath.row]
        cell.textLabel?.text = content.type
        cell.selectionStyle = .none
        return cell
    }
    
}


extension ProfileViewController: UITableViewDelegate  {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = viewModel.contents[indexPath.row]
        switch content {
        case .about:
            print(content.type)
            delegate?.didClickAboutButton()
        case .login:
            print(content.type)
            delegate?.didClickLoginButton()
        case .logout:
            print(content.type)
            delegate?.didClickLogoutButton()
        }
    }
}
