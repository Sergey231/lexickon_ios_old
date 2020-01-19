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
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(LoginView.self) { r in
            LoginView(presenter: r.resolve(LoginPresenter.self)!)
        }.inObjectScope(ObjectScope.appObjectScope)
    }
    
}
