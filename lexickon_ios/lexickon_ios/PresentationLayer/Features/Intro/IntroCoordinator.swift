//
//  IntroCoordinator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

final class IntroCoordinator: _Coordinator {
    
    var completions: RouterCompletions = [:]
    var childCoordinators: [_Coordinator] = []
    var finishFlow: CompletionBlock?
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startFlow() {
        let vc = DI.shr.assembler.resolver.resolve(IntroPageViewController.self)!
        present(vc)
    }
}
