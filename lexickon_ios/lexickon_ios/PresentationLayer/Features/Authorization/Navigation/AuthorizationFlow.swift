//
//  AuthorizationFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 05.04.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow

enum AuthorizationStep: Step {
    case start
    case login
    case registrate
    case begin
}

class AuthorizationFlow: Flow {
    
    var root: Presentable {
        self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.topItem?.title = "OnBoarding"
        return viewController
    }()
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AuthorizationStep else { return .none }
        
        switch step {
            
        case .start:
            let startViewController = AuthorizationAssembler.shr.assembler.resolver.resolve(
                StartViewController.self
            )!
            self.rootViewController.pushViewController(startViewController, animated: true)
            return .one(flowContributor: .contribute(withNext: startViewController))
        case .login:
            let loginVC = AuthorizationAssembler.shr.assembler.resolver.resolve(
                LoginViewController.self
            )!
            return .one(flowContributor: .contribute(withNext: loginVC))
        case .registrate:
            let registratioinVC = AuthorizationAssembler.shr.assembler.resolver.resolve(
                RegistrationViewController.self
            )!
            return .one(flowContributor: .contribute(withNext: registratioinVC))
        case .begin:
            return .none
        }
    }
}
