//
//  ProfileCoordinator.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    var coordinators: [Coordinator] = []
    
    let navigationController: NavigationController
    
    lazy var viewModel: ProfileViewModel = {
        let viewModel = ProfileViewModel()
        return viewModel
    }()
    
    lazy var rootViewController: ProfileViewController = {
        let vc = ProfileViewController(viewModel: viewModel)
        return vc
    }()
    
    init(navigationController: NavigationController = NavigationController()) {
        self.navigationController = navigationController
        
    }
    
    func start() {
        navigationController.viewControllers = [rootViewController]
    }

    
}
