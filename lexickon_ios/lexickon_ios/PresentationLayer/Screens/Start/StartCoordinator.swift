//
//  StartCoordinator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

final class StartCoordinator: _Coordinator {
    
    var completions: RouterCompletions = [:]
    var childCoordinators: [_Coordinator] = []
    var finishFlow: CompletionBlock?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startFlow() {
        let vc = DI.shr.assembler.resolver.resolve(StartViewController.self)!
        vc.coordinator = self
        vc.onCompletion = finishFlow
        setRootModule(vc, hideBar: true, animated: true)
    }
    
    func createAccount() {
        let registrationCoordinator = DI.shr.assembler.resolver.resolve(
            RegistrationCoordinator.self,
            argument: navigationController
        )!
        addChild(registrationCoordinator)
        registrationCoordinator.startFlow()
    }
    
    func login() {
        let loginCoordinator = DI.shr.assembler.resolver.resolve(
            LoginCoordinator.self,
            argument: navigationController
        )!
        addChild(loginCoordinator)
        loginCoordinator.startFlow()
    }
    
    func main() {
        let mainCoordinator = DI.shr.assembler.resolver.resolve(
            MainCoordinator.self,
            argument: navigationController
        )!
        addChild(mainCoordinator)
        mainCoordinator.startFlow()
    }
}
