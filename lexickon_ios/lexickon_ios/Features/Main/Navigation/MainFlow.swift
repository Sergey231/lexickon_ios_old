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
        let profileMainScreenVC = ProfileAssembler.shr.assembler.resolver.resolve(
            ProfileMainScreenViewController.self
        )!
        (root as! UINavigationController).pushViewController(profileMainScreenVC, animated: true)
        return .one(flowContributor: .contribute(withNext: profileMainScreenVC))
    }
}
