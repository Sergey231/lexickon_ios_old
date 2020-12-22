//
//  AppAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 4/29/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Swinject

extension ObjectScope {
    
    static let appObjectScope = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "appObjectScope"
    )
    
    static let mainObjectScope = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "mainObjectScope",
        parent: ObjectScope.appObjectScope
    )
}

final class DI {
    
    static let shr = DI()
    
    let appAssembler: Assembler
    let appContainer: Container
    
    init() {
        appContainer = Container()
        appAssembler = Assembler(container: appContainer)
    }
}
