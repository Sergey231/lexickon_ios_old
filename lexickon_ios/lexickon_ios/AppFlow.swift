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
    case intro
    case authorization
    case main
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
        case .intro:
            return navigationToIntro()
        case .main:
            return navigationToMain()
        }
    }
    
    private func navigationToAuthorization() -> FlowContributors {
        
        let authorizationFlow = AuthorizationFlow()
        
        Flows.whenReady(flow1: authorizationFlow) { [unowned self] root in
            let viewControllers = (root as! UINavigationController).viewControllers
            self.rootViewController.setViewControllers(viewControllers, animated: true)
        }
        
        return .one(flowContributor: .contribute(
            withNextPresentable: authorizationFlow,
            withNextStepper: OneStepper(withSingleStep: AuthorizationStep.start)
        ))
    }
    
    private func navigationToIntro() -> FlowContributors {
        return .none
    }
    
    private func navigationToMain() -> FlowContributors {
        return .none
    }
}

final class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return AppStep.authorization
    }
    
    func appRoute(
        isSeenIntro: Bool,
        isAuthorized: Bool
    ) -> AppStep {
        switch (isSeenIntro, isAuthorized) {
        case (false, false), (true, false):
            return .authorization
        case (false, true):
            return .intro
        case (true, true):
            return .main
        }
    }
}
