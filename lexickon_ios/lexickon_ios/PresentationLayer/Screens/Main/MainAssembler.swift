//
//  MainAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

final class MainAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(MainPresenter.self) { _ in
            MainPresenter()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(MainViewController.self) { r in
            MainViewController(presenter: r.resolve(MainPresenter.self)!)
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(MainCoordinator.self) { resolver, nc in
            MainCoordinator(navigationController: nc)
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
