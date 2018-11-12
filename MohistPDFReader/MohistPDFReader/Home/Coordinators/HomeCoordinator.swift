//
//  HomeCoordinator.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class HomeCoordinator: Coordinator {
    let navigationController: NavigationController
    var coordinators: [Coordinator] = []
    
    lazy var rootViewController: HomeViewController = {
        let vc = HomeViewController()
        return vc
    }()
    
    init(
        navigationController: NavigationController = NavigationController()){
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.viewControllers = [rootViewController]
    }
}
