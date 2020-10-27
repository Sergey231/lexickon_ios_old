//
//  ProfileFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow

enum ProfileStep: Step {
    case profileMainScreen(UIViewControllerTransitioningDelegate?)
    case logout
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
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ProfileStep else { return .none }
        
        switch step {
        
        case .profileMainScreen(let transitioningDelegate):
            return navigateToProfileMainScreen(transitioningDelegate: transitioningDelegate)
        case .logout:
            return navigateToAuthorization()
        }
    }
    
    private func navigateToProfileMainScreen(
        transitioningDelegate: UIViewControllerTransitioningDelegate?
    ) -> FlowContributors {
        let profileMainScreenVC = ProfileAssembler.shr.assembler.resolver.resolve(
            ProfileMainScreenViewController.self
        )!
        profileMainScreenVC.transitioningDelegate = transitioningDelegate
        (root as! UINavigationController).pushViewController(profileMainScreenVC, animated: true)
        return .one(flowContributor: .contribute(withNext: profileMainScreenVC))
    }
    
    private func navigateToAuthorization() -> FlowContributors {
        DI.shr.appContainer.resetObjectScope(.profileScopeObject)
        return .end(forwardToParentFlowWithStep: MainStep.authorization)
    }
}
