//
//  SignInSignupCoordinator.swift
//  MohistPDFReader
//
//  Created by mozhe on 2018/11/10.
//  Copyright © 2018 mozhe. All rights reserved.
//

import UIKit

final class SignInSignupCoordinator: NSObject, Coordinator {
    
    let navigationController: NavigationController
    var coordinators: [Coordinator] = []
    
    lazy var viewModel = LoginViewModel()
    
    lazy var loginViewController: SignInSignupViewController = {
        let vc = SignInSignupViewController(viewModel: viewModel)
        vc.delegate = self
        return vc
    }()
    
    lazy var verificationController: SmsCodeViewController = {
        let smsViewModel = SmsViewModel(phone: viewModel.localPhoneNumber!, codeCount: 4)
        let vc = SmsCodeViewController(viewModel: smsViewModel)
        return vc
    }()
    
    init(navigationController: NavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        loginViewController.navigationItem.backBarButtonItem = .back
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    
}

extension SignInSignupCoordinator: SignInSignUpViewControllerDelegate {
    func didClickVerificationCode(with phone: String){
        verificationController.navigationItem.backBarButtonItem = .back
        navigationController.pushViewController(verificationController, animated: true)
    }
}


