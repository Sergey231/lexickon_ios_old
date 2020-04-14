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
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        self.rootViewController = root
    }
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AuthorizationStep else { return .none }
        
        switch step {
            
        case .start:
            return navigateToStart()
        case .login:
            return navigateToLogin()
        case .registrate:
            return navigateToRegistration()
        case .begin:
            return .end(forwardToParentFlowWithStep: AppStep.main)
        }
    }
    
    private func navigateToStart() -> FlowContributors {
        let startVC = AuthorizationAssembler.shr.assembler.resolver.resolve(
            StartViewController.self
        )!
        (root as! UINavigationController).pushViewController(startVC, animated: true)
        return .one(flowContributor: .contribute(withNext: startVC))
    }
    
    private func navigateToLogin() -> FlowContributors {
        let loginVC = AuthorizationAssembler.shr.assembler.resolver.resolve(
            LoginViewController.self
        )!
        (root as! UINavigationController).pushViewController(loginVC, animated: true)
        return .one(flowContributor: .contribute(withNext: loginVC))
    }
    
    private func navigateToRegistration() -> FlowContributors {
        let registratioinVC = AuthorizationAssembler.shr.assembler.resolver.resolve(
            RegistrationViewController.self
        )!
        (root as! UINavigationController).pushViewController(registratioinVC, animated: true)
        return .one(flowContributor: .contribute(withNext: registratioinVC))
    }
}
