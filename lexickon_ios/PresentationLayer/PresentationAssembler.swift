//
//  PresentationAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 4/30/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Swinject

final class PresentationAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(StartPresenterProtocol.self) { _ in
            StartPresenter()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(StartView.self) { r in
            StartView(presenter: r.resolve(StartPresenterProtocol.self)!)
        }.inObjectScope(ObjectScope.appObjectScope)
        
        
        container.register(RegistrationPresenter.self) { _ in
            RegistrationPresenter()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(RegistrationView.self) { r in
            RegistrationView(presenter: r.resolve(RegistrationPresenter.self)!)
        }.inObjectScope(ObjectScope.appObjectScope)
        
    }
}
