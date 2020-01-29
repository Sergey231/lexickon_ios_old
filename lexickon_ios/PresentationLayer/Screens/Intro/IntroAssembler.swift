//
//  IntroAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

final class IntroAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(IntroPageViewController.self) { _ in
            IntroPageViewController()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(IntroViewController.self) { _ in
            IntroViewController()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(IntroCoordinator.self) { resolver, nc in
            IntroCoordinator(navigationController: nc)
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
