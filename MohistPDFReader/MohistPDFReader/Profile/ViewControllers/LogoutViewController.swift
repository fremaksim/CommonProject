//
//  LogoutViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/15.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class LogoutViewController: UIViewController {
    
    let viewModel: LogoutViewModel = LogoutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        view.backgroundColor = viewModel.backgroundColor
    }

}
