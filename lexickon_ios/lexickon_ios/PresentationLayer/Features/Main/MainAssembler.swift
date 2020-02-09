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
        
        container.register(MainViewController.self) { resolver, router in
            MainViewController(
                presenter: resolver.resolve(MainPresenter.self)!,
                router: router
            )
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
