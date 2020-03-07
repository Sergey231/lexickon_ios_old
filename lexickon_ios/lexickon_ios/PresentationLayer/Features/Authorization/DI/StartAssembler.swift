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
        }.inObjectScope(ObjectScope.startObjectScope)
        
        container.register(StartViewController.self) { resolver, router in
            StartViewController(
                presenter: resolver.resolve(StartPresenter.self)!,
                router: router,
                container: container
            )
        }.inObjectScope(ObjectScope.startObjectScope)
    }
}

extension ObjectScope {
    
    static let startObjectScope = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "startObjectScope",
        parent: ObjectScope.appObjectScope
    )
}
