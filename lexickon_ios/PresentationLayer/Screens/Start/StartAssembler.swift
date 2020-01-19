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
        
        container.register(StartPresenterProtocol.self) { _ in
            StartPresenter()
        }.inObjectScope(ObjectScope.appObjectScope)
        
        container.register(StartView.self) { r in
            StartView(presenter: r.resolve(StartPresenterProtocol.self)!)
        }.inObjectScope(ObjectScope.appObjectScope)
    }
}
