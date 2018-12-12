//
//  ViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // welcome ads page
    let types = [
        "Welcome multiImages",
        
        "AD single image",
        "AD multiImages",
        "AD short Video",
        
        "LoginIn"
    ]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate   = self
        tableView.dataSource = self
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加欢迎页
        addWelcomeAdsSample()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    /// 欢迎页 广告页
    private func  addWelcomeAdsSample(){
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        
    }
    
    private func signinSignupSample(){
        let vc = SignInSignupViewController(viewModel: LoginViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var  pageViewWelcomeViewModel = ADPageViewWelcomeViewModel(guideType: .welcome, page: AdPage.testPage(type: .multiImages))
        switch indexPath.row {
        case 0:
            pageViewWelcomeViewModel = ADPageViewWelcomeViewModel(guideType: .welcome, page: AdPage.testPage(type: .multiImages))
            addPageViewController(viewModel: pageViewWelcomeViewModel)
        case 1:
            pageViewWelcomeViewModel = ADPageViewWelcomeViewModel(guideType: .ad, page: AdPage.testPage(type: .singleImage))
            addPageViewController(viewModel: pageViewWelcomeViewModel)
        case 2:
            pageViewWelcomeViewModel = ADPageViewWelcomeViewModel(guideType: .ad, page: AdPage.testPage(type: .multiImages))
            addPageViewController(viewModel: pageViewWelcomeViewModel)
        case 3:
            pageViewWelcomeViewModel = ADPageViewWelcomeViewModel(guideType: .ad, page: AdPage.testPage(type: .shortVideo))
            addPageViewController(viewModel: pageViewWelcomeViewModel)
        case 4:
            signinSignupSample()
        default:
            print(indexPath.row)
        }
        
        
        
    }
    
    private func addPageViewController(viewModel: ADPageViewWelcomeViewModel){
        let adPageViewController = ADPageWelcomeViewController(viewModel: viewModel) { [weak self] (webURL) in
            let adWeb = AdWeb(url: webURL)
            let webViewModel = AdWebViewModel(adWeb: adWeb)
            let webViewController = AdWebViewController(viewModel: webViewModel)
            
            self?.navigationController?.pushViewController(webViewController, animated: true)
        }
        
        addChild(adPageViewController)
        adPageViewController.view.bounds = UIScreen.main.bounds
        view.addSubview(adPageViewController.view)
    }
    
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell"){
            cell.textLabel?.text = types[indexPath.row]
            return cell
        }else{
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            cell.textLabel?.text = types[indexPath.row]
            return cell
        }
        
    }
}

