//
//  WordCordFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.06.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow
import Resolver
import KeychainRepository
import UserRepository
import AuthTokenRepository

enum WordCardStep: Step {
    case word
    case home
    case exercise
}

class WordCardFlow: Flow {
    
    var root: Presentable {
        rootViewController
    }
    
    private let rootViewController: UINavigationController
    
    init(with root: UINavigationController) {
        rootViewController = root
    }
    
    // For Navigation debug
    deinit {
        print("\(type(of: self)): \(#function)")
    }

    // Reduce function
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? WordCardStep else { return .none }
        
        switch step {
            
        case .word:
            return .none
        case .home:
            return .none
        case .exercise:
            return .none
        }
    }
    
    // Side Effects
    private func navigateToWord() -> FlowContributors {
        let startVC: StartViewController = Resolver.resolve()
        (root as! UINavigationController).pushViewController(startVC, animated: true)
        return .one(flowContributor: .contribute(withNext: startVC))
    }
    
    private func navigateToHome() -> FlowContributors {
        .end(forwardToParentFlowWithStep: MainStep.home(animated: true))
    }
    
    private func navigateToExercise() -> FlowContributors {
        let registrationVC: RegistrationViewController = Resolver.resolve()
        (root as! UINavigationController).pushViewController(registrationVC, animated: true)
        return .one(flowContributor: .contribute(withNext: registrationVC))
    }
}

// MARK: Registering all needed objects in the DI Container for this Flow
extension Resolver {
    public static func registerWordCardObjects() {
        
        register { StartViewController() }
    }
}
