//
//  AppFlow.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 05.04.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxFlow
import RxCocoa
import RxSwift

enum AppStep: Step {
    case authorization
    case main(animated: Bool)
}

final class AppFlow: Flow {
    
    var root: Presentable {
        self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    deinit {
        print("\(type(of: self)): \(#function)")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }

        switch step {
        case .authorization:
            return navigationToAuthorization()
        case .main(let animated):
            return navigationToMain(animated: animated)
        }
    }
    
    private func navigationToAuthorization() -> FlowContributors {
        
        let authorizationFlow = AuthorizationFlow(with: rootViewController)
        return .one(flowContributor: .contribute(
            withNextPresentable: authorizationFlow,
            withNextStepper: OneStepper(withSingleStep: AuthorizationStep.start)
        ))
    }
    
    private func navigationToMain(animated: Bool) -> FlowContributors {
        
        let mainFlow = MainFlow(with: rootViewController)
        return .one(flowContributor: .contribute(
            withNextPresentable: mainFlow,
            withNextStepper: OneStepper(withSingleStep: MainStep.home(animated: animated))
        ))
    }
}

final class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    
    var initialStep: Step {
        AppStep.authorization
    }
}
