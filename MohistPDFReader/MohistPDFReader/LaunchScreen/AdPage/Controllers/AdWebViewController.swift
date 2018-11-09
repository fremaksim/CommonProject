//
//  AdWebViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/7.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit
import WebKit

class AdWebViewController: UIViewController {
    
    let viewModel: AdWebViewModel
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    init(viewModel: AdWebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
            ])
        guard  let urlString = viewModel.url,
            let url = URL(string: urlString) else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    deinit {
        print("\(self) deinit")
    }
    
}
