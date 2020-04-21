//
//  IntroAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

final class IntroAssemly: Assembly {
    
    func assemble(container: Container) {
        container.register(IntroViewController.self) { _ in
            IntroViewController()
        }.inObjectScope(ObjectScope.introObjectScope)
    }
}
