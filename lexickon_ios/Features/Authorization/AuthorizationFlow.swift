//
//  AuthorizationFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 05.04.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow
import Resolver

enum AuthorizationStep: Step {
    case start
    case login
    case registrate
    case begin(animated: Bool)
}

class AuthorizationFlow: Flow {
    
    var root: Presentable {
        rootViewController
    }
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        rootViewController = root
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
        case .begin(let animated):
            return navigateToMain(animated: animated)
        }
    }
    
    private func navigateToStart() -> FlowContributors {
        let startVC: StartViewController = Resolver.resolve()
        (root as! UINavigationController).pushViewController(startVC, animated: true)
        return .one(flowContributor: .contribute(withNext: startVC))
    }
    
    private func navigateToLogin() -> FlowContributors {
        let loginVC: LoginViewController = Resolver.resolve()
        (root as! UINavigationController).pushViewController(loginVC, animated: true)
        return .one(flowContributor: .contribute(withNext: loginVC))
    }
    
    private func navigateToRegistration() -> FlowContributors {
        let registrationVC: RegistrationViewController = Resolver.resolve()
        (root as! UINavigationController).pushViewController(registrationVC, animated: true)
        return .one(flowContributor: .contribute(withNext: registrationVC))
    }
    
    private func navigateToMain(animated: Bool) -> FlowContributors {
        return .end(forwardToParentFlowWithStep: AppStep.main(animated: animated))
    }
}

extension Resolver {
    public static func registerAuthorisationObjects() {
        
        register { StartViewController() }
        register { StartPresenter() }
        register { LoginViewController() }
        register { LoginPresenter() }
        register { RegistrationViewController() }
        register { RegistrationPresenter() }
        register { AuthorizationInteractor() as AuthorizationInteractorProtocol }
        register { UserRepository() as UserRepositoryProtocol }
        register { AuthTokenRepository() as AuthTokenRepositoryProtocol }
    }
}
