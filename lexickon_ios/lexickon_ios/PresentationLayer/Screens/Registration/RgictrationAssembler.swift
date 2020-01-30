//
//  RgictrationAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 19.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

final class RegistrationAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(RegistrationPresenter.self) { _ in
            RegistrationPresenter()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(RegistrationViewController.self) { resolver in
            RegistrationViewController(presenter: resolver.resolve(RegistrationPresenter.self)!)
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(RegistrationCoordinator.self) { resolver, nc in
            RegistrationCoordinator(navigationController: nc)
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
