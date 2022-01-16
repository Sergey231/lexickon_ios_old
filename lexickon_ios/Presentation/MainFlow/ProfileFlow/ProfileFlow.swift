//
//  ProfileFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow
import Resolver
// import AuthTokenRepository

enum ProfileStep: Step {
    case profileMainScreen
    case toHome
    case logout
    case addWord
}

class ProfileFlow: Flow {
    
    var root: Presentable {
        rootViewController
    }
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        rootViewController = root
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ProfileStep else { return .none }
        
        switch step {
        
        case .profileMainScreen:
            return navigateToProfileMainScreen()
        case .toHome:
            return navigateToHome()
        case .logout:
            return navigateToAuthorization()
        case .addWord:
            return navigateToAddWord()
        }
    }
    
    private func navigateToProfileMainScreen() -> FlowContributors {
        let vc: ProfileMainScreenViewController = Resolver.resolve()
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToHome() -> FlowContributors {
        rootViewController.popToRootViewController(animated: true)
        return .end(forwardToParentFlowWithStep: MainStep.home(animated: false))
    }
    
    private func navigateToAuthorization() -> FlowContributors {
        return .end(forwardToParentFlowWithStep: MainStep.authorization)
    }
    
    private func navigateToAddWord() -> FlowContributors {
        rootViewController.popToRootViewController(animated: true)
        return .end(forwardToParentFlowWithStep: MainStep.addWord)
    }
}

// MARK: Registering all needed objects in the DI Container for this Flow
extension Resolver {
    public static func registerProfileObjects() {
        register { ProfileMainScreenViewController() }
        register { ProfileMainScreenPresenter() }
        register { AuthTokenRepository() as AuthTokenRepositoryProtocol }
        register { LogoutUseCase() }
        
        register { ProfileInteractor() as ProfileInteractorProtocol }
    }
}
