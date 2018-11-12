//
//  WelcomeViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var viewModel = WelcomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure(viewModel: viewModel)
    }
    
    func configure(viewModel: WelcomeViewModel) {
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
    }
    
    
}
