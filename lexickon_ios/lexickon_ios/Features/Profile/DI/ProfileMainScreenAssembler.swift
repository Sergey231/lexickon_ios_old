//
//  ProfileInfo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

struct ProfileMainScreenAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(ProfileMainScreenPresenter.self) { _ in
            ProfileMainScreenPresenter()
        }.inObjectScope(.profileScopeObject)
        
        container.register(ProfileMainScreenViewController.self) { resolver in
            ProfileMainScreenViewController(
                presenter: resolver.resolve(ProfileMainScreenPresenter.self)!
            )
        }.inObjectScope(.profileScopeObject)
    }
}
