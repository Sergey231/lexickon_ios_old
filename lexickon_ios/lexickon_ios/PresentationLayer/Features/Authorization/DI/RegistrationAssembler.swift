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
        }.inObjectScope(ObjectScope.registrationObjectScope)
        
        container.register(RegistrationViewController.self) { resolver, router in
            RegistrationViewController(
                presenter: resolver.resolve(RegistrationPresenter.self)!,
                router: router
            )
        }.inObjectScope(ObjectScope.registrationObjectScope)
    }
}

extension ObjectScope {
    
    static let registrationObjectScope = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "registrationObjectScope",
        parent: ObjectScope.authorizationObjectScope
    )
}

