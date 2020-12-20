//
//  AddSearchWordAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

struct AddSearchWordAssembler: Assembly {
    
    func assemble(container: Container) {
        
        container.register(AddSearchWordPresenter.self) { _ in
            AddSearchWordPresenter()
        }.inObjectScope(ObjectScope.newWordScopeObject)
        
        container.register(AddSearchWordViewController.self) { resolver in
            AddSearchWordViewController(presenter: resolver.resolve(AddSearchWordPresenter.self)!)
        }
    }
}

