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
        
        container.register(HomePresenter.self) { _ in
            HomePresenter()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(HomeViewController.self) { resolver in
            HomeViewController(
                presenter: resolver.resolve(HomePresenter.self)!
            )
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
