//
//  HomeAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

final class HomeAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(WordRepositoryProtocol.self) { _ in
            WordRepository()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(MainInteractorProtocol.self) { resolver in
            MainInteractor(
                wordRepository: resolver.resolve(WordRepositoryProtocol.self)!
            )
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(HomePresenter.self) { resolver in
            HomePresenter(
                mainInteractor: resolver.resolve(MainInteractorProtocol.self)!
            )
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(HomeViewController.self) { resolver in
            HomeViewController(
                presenter: resolver.resolve(HomePresenter.self)!
            )
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
