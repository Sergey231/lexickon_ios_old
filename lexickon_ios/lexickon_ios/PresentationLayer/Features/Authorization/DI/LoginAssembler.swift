//
//  LoginAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

final class LoginAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(LoginPresenter.self) { _ in
            LoginPresenter()
        }.inObjectScope(ObjectScope.loginObjectScope)
        
        container.register(LoginViewController.self) { resolver, router in
            LoginViewController(
                presenter: resolver.resolve(LoginPresenter.self)!,
                router: router
            )
        }.inObjectScope(ObjectScope.loginObjectScope)
    }
    
}

extension ObjectScope {
    
    static let loginObjectScope = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "loginObjectScope",
        parent: ObjectScope.authorizationObjectScope
    )
}
