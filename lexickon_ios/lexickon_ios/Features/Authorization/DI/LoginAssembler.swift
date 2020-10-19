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
        
        container.register(UserRepositoryProtocol.self) { _ in
            UserRepository()
        }
        
        container.register(UserTokenRepositoryProtocol.self) { _ in
            UserTokenRepository()
        }
        
        container.register(AuthorizationInteractorProtocol.self) { resolver in
            AuthorizationInteractor(
                userTokenRepository: resolver.resolve(UserTokenRepositoryProtocol.self)!,
                userRepository: resolver.resolve(UserRepositoryProtocol.self)!
            )
        }
        
        container.register(LoginPresenter.self) { resolver in
            LoginPresenter(
                authorisationInteractor: resolver.resolve(AuthorizationInteractorProtocol.self)!
            )
        }.inObjectScope(ObjectScope.loginObjectScope)
        
        container.register(LoginViewController.self) { resolver in
            LoginViewController(
                presenter: resolver.resolve(LoginPresenter.self)!
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
