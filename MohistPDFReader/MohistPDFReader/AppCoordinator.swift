//
//  AppCoordinator.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

class AppCoordinator: NSObject,Coordinator {
    
    // Properties
    let navigationController: NavigationController
    var coordinators: [Coordinator] = []
    
    var inCoordinator: InCoordinator? {
        return self.coordinators.compactMap { $0 as? InCoordinator }.first
    }
    
    //MARK: --- Life Cycle
    init(window: UIWindow,navigationController: NavigationController = NavigationController()) {
        self.navigationController = navigationController
        super.init()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        
        let coordinator = InCoordinator(navigationController: navigationController)
        coordinator.start()
        addCoordinator(coordinator)
        
    }
    
    
}


