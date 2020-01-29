//
//  MainCoordinator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    
    var completions: RouterCompletions = [:]
    var childCoordinators: [Coordinator] = []
    var finishFlow: CompletionBlock?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startFlow() {
        let vc = DI.shr.assembler.resolver.resolve(MainViewController.self)!
        vc.coordinator = self
        setRootModule(vc, hideBar: true, animated: true)
    }
}
