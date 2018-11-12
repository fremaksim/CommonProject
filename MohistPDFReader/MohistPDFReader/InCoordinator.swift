//
//  InCoordinator.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class InCoordinator: Coordinator {
    
    let navigationController: NavigationController
    var coordinators: [Coordinator] = []
    
    init(navigationController: NavigationController = NavigationController()) {
        self.navigationController = navigationController
    }
    
    func start() {
        showTabBar()
    }
    
    func showTabBar() {
        
        let viewModel = InCoordinatorViewModel()
        
        let tabBarController = TabBarController()
        tabBarController.tabBar.isTranslucent = false
        
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.start()
        homeCoordinator.rootViewController.tabBarItem = viewModel.homeBarItem
        addCoordinator(homeCoordinator)
        
        let discoveryCoordinator = DiscoveryCoordinator()
        discoveryCoordinator.start()
        discoveryCoordinator.rootViewController.tabBarItem = viewModel.discoveryBarItem
        addCoordinator(discoveryCoordinator)
        
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.start()
        profileCoordinator.rootViewController.tabBarItem = viewModel.profileBarItem
        addCoordinator(profileCoordinator)
        
        tabBarController.viewControllers = [
            homeCoordinator.navigationController.childNavigationController,
            discoveryCoordinator.navigationController.childNavigationController,
            profileCoordinator.navigationController.childNavigationController
        ]
        
        navigationController.setViewControllers([tabBarController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        
        
        showTab()
    }
    
    
    ///
    func showTab()  {
        
    }
    
    
}
