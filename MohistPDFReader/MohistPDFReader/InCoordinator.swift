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
    
    var tabBarController: UITabBarController? {
        return self.navigationController.viewControllers.first as? UITabBarController
    }
    
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
        tabBarController.selectedIndex = 0
        
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
        
        
        //        showTab()
    }
    
    func showTab()  {
        guard let viewControllers = tabBarController?.viewControllers else { return }
        guard let nav = viewControllers[tabBarController!.selectedIndex] as? UINavigationController else { return }
        
        tabBarController?.selectedViewController = nav
        
    }
    
    
}
