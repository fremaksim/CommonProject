//
//  AboutViewController.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/15.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    let viewModel: AboutViewModel = AboutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = viewModel.backgroundColor
        title = viewModel.title
        
    }
    
}
