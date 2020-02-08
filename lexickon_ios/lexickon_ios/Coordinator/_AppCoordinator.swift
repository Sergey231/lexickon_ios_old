//
//  MainCoordinator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 23.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import Swinject
import XCoordinator

enum AppRoute: Route {
    case intro
    case authorization
    case main
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    
    
    init() { super.init(initialRoute: .authorization) }
    
    fileprivate var instructor: AppRoute {
        return AppCoordinator.setup(isSeenIntro: false, isAuthorized: false)
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .authorization:
            let startViewController = DI.shr.assembler.resolver.resolve(
                StartViewController.self, argument: unownedRouter
                )!
            return .push(startViewController)
        case .intro:
            let introVC = DI.shr.assembler.resolver.resolve(IntroViewController.self)!
            return .present(introVC)
        case .main:
            let mainVC = DI.shr.assembler.resolver.resolve(MainViewController.self)!
            return .push(mainVC)
        }
    }
    
    static func setup(
        isSeenIntro: Bool,
        isAuthorized: Bool
    ) -> AppRoute {
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

final class _AppCoordinator: _Coordinator {
    
    var completions: RouterCompletions = [:]
    var childCoordinators: [_Coordinator] = []
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
