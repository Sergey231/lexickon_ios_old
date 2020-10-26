//
//  MainFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 15.04.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow

enum MainStep: Step {
    case home(animated: Bool)
    case profile
    case authorization
}

class MainFlow: Flow {
    
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
        guard let step = step as? MainStep else { return .none }
        
        switch step {
            
        case .home(let animated):
            return navigateToHome(animated: animated)
        case .profile:
            return navigateToProfile()
        case .authorization:
            return navigateToAuthorization()
        }
    }
    
    private func navigateToHome(animated: Bool) -> FlowContributors {
        let homeVC = MainAssembler.shr.assembler.resolver.resolve(
            HomeViewController.self
        )!
        (root as! UINavigationController).setViewControllers([homeVC], animated: animated)
        return .one(flowContributor: .contribute(withNext: homeVC))
    }
    
    private func navigateToProfile() -> FlowContributors {
        let profileFlow = ProfileFlow(with: rootViewController)
        return .one(flowContributor: .contribute(
            withNextPresentable: profileFlow,
            withNextStepper: OneStepper(withSingleStep: ProfileStep.profileMainScreen)
        ))
    }
    
    private func navigateToAuthorization() -> FlowContributors {
        DI.shr.appContainer.resetObjectScope(.mainObjectScope)
        return .end(forwardToParentFlowWithStep: AppStep.authorization)
    }
}
