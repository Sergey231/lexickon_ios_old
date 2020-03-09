//
//  StartCoordinator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import XCoordinator

enum AuthorizationRoute: Route {
    case start
    case login
    case registrate
    case begin
}

final class AuthorizationCoordinator: NavigationCoordinator<AuthorizationRoute> {
    
    private let appRouter: UnownedRouter<AppRoute>
    
    init(
        rootViewController: UINavigationController,
        appRouter: UnownedRouter<AppRoute>
    ) {
        self.appRouter = appRouter
        super.init(
            rootViewController: rootViewController,
            initialRoute: nil
        )
        trigger(.start)
    }
    
    // MARK: - for SwiftUI/Preview
    static func empty() -> UnownedRouter<AuthorizationRoute> {
        return AuthorizationCoordinator(
            rootViewController: UINavigationController(),
            appRouter: AppCoordinator().unownedRouter
        ).unownedRouter
    }
    
    override func prepareTransition(for route: AuthorizationRoute) -> NavigationTransition {
        
        switch route {
            
        case .start:
            let startViewController = AuthorizationAssembler.shr.assembler.resolver.resolve(
                StartViewController.self,
                argument: unownedRouter
            )!
            return .push(startViewController)
        case .login:
            let loginVC = AuthorizationAssembler.shr.assembler.resolver.resolve(
                LoginViewController.self,
                argument: unownedRouter
            )!
            return .push(loginVC)
        case .registrate:
            let registratioinVC = AuthorizationAssembler.shr.assembler.resolver.resolve(
                RegistrationViewController.self,
                argument: unownedRouter
            )!
            return .push(registratioinVC)
        case .begin:
            appRouter.trigger(.main)
            return .none()
        }
    }
}
