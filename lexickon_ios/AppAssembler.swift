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
    
    static let loginObjectScope = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "loginObjectScope",
        parent: ObjectScope.appObjectScope
    )
}

final class DI {
    
    static let share = DI()
    let assembler: Assembler
    
    init() {
        assembler = Assembler(
            PresentationLayerAssemblers.assemblers
            + DataLayerAssemblers.assemblers
            + DomainLayerAssemblers.assemblers
        )
    }
    
}
