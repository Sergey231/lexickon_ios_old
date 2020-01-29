//
//  StartAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 19.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

final class StartAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(StartPresenter.self) { _ in
            StartPresenter()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(StartViewController.self) { r in
            StartViewController(presenter: r.resolve(StartPresenter.self)!)
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(StartCoordinator.self) { resolver, nc in
            StartCoordinator(navigationController: nc)
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
