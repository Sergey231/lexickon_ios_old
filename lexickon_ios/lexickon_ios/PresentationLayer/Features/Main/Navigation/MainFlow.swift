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
    case home
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
            
        case .home:
            return navigateToHome()
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        let homeVC = MainAssembler.shr.assembler.resolver.resolve(
            HomeViewController.self
            )!
        (root as! UINavigationController).pushViewController(homeVC, animated: true)
        return .one(flowContributor: .contribute(withNext: homeVC))
    }
}
