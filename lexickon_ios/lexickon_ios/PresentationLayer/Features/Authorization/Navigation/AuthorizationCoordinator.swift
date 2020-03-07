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
            let startViewController = AuthorizationAssembler.shr.assembler.resolver.resolve(
                StartViewController.self,
                argument: unownedRouter
            )!
            return .push(startViewController)
        case .begin:
            let mainCoordinator = MainCoordinator(rootViewController: self.rootViewController)
            return .route(.home, on: mainCoordinator)
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
        }
    }
}
