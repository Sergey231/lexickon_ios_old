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
    case begin
    case login
    case registrate
}

final class AuthorizationCoordinator: NavigationCoordinator<AuthorizationRoute> {
    
    init(rootViewController: UINavigationController) {
        super.init(
            rootViewController: rootViewController,
            initialRoute: nil
        )
        trigger(.start)
    }
    
    override func prepareTransition(for route: AuthorizationRoute) -> NavigationTransition {
        
        switch route {
            
        case .start:
            let startViewController = DI.shr.assembler.resolver.resolve(
                StartViewController.self,
                argument: unownedRouter
                )!
            return .push(startViewController)
        case .begin:
            let mainVC = DI.shr.assembler.resolver.resolve(
                MainViewController.self,
                argument: unownedRouter
                )!
            return .push(mainVC)
        case .login:
            let loginVC = DI.shr.assembler.resolver.resolve(
                LoginViewController.self,
                argument: unownedRouter
            )!
            return .push(loginVC)
        case .registrate:
            let registratioinVC = DI.shr.assembler.resolver.resolve(
                RegistrationViewController.self,
                argument: unownedRouter
            )!
            return .push(registratioinVC)
        }
    }
}
