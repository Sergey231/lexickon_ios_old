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
        
        container.register(RegistrationPresenter.self) { resolver in
            RegistrationPresenter(
                authorisationInteractor: resolver.resolve(AuthorizationInteractorProtocol.self)!
            )
        }.inObjectScope(ObjectScope.registrationObjectScope)
        
        container.register(RegistrationViewController.self) { resolver in
            RegistrationViewController(
                presenter: resolver.resolve(RegistrationPresenter.self)!
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

