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
    
    init() {
        super.init(initialRoute: Self.appRoute(isSeenIntro: false, isAuthorized: false))
    }
    
    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .authorization:
            let authorizationCoordinator = AuthorizationCoordinator(rootViewController: self.rootViewController)
            addChild(authorizationCoordinator)
            return .none()
            
        case .intro:
            let introVC = DI.shr.assembler.resolver.resolve(
                IntroViewController.self,
                argument: unownedRouter
                )!
            return .push(introVC)
        case .main:
            let mainCoordinator = MainCoordinator(rootViewController: self.rootViewController)
            addChild(mainCoordinator)
            return .none()
        }
    }
    
    static func appRoute(
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
