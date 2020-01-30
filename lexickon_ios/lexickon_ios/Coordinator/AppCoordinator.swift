//
//  MainCoordinator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 23.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import Swinject

fileprivate enum LaunchInstructor {
    case intro
    case authorization
    case main
    
    static func setup(
        isSeenIntro: Bool,
        isAuthorized: Bool
    ) -> LaunchInstructor {
        switch (isSeenIntro, isAuthorized) {
        case (false, false), (true, false):
            return .authorization
        case (false, true):
            return .intro
        case (true, true):
            return main
        }
    }
}

final class AppCoordinator: Coordinator {
    
    var completions: RouterCompletions = [:]
    var childCoordinators: [Coordinator] = []
    var finishFlow: CompletionBlock?
    var navigationController: UINavigationController
    
    fileprivate var instructor: LaunchInstructor {
        return LaunchInstructor.setup(isSeenIntro: false, isAuthorized: false)
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startFlow() {
        switch instructor {
        case .intro:
            self.performIntroFlow()
        case .authorization:
            self.performAuthorizationFlow()
        case .main:
            self.performMainFlow()
        }
    }
    
    private func performIntroFlow() {
        let coordinator = DI.shr.assembler.resolver.resolve(
            IntroCoordinator.self,
            argument: navigationController
        )!
        coordinator.finishFlow = { [weak self, weak coordinator] in
            guard
                let `self` = self,
                let `coordinator` = coordinator
                else { return }
//            Session.isSeenIntro = true
            self.startFlow()
            self.removeChild(coordinator)
        }
        addChild(coordinator)
        coordinator.startFlow()
    }
    
    private func performAuthorizationFlow() {
        let coordinator = DI.shr.assembler.resolver.resolve(
            StartCoordinator.self,
            argument: navigationController
        )!
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.removeChild(coordinator)
            self.startFlow()
        }
        addChild(coordinator)
        coordinator.startFlow()
    }
    
    private func performMainFlow() {
        let coordinator = DI.shr.assembler.resolver.resolve(
            MainCoordinator.self,
            argument: navigationController
        )!
        coordinator.finishFlow = { [unowned self, unowned coordinator] in
            self.startFlow()
            self.removeChild(coordinator)
        }
        addChild(coordinator)
        coordinator.startFlow()
    }
}
