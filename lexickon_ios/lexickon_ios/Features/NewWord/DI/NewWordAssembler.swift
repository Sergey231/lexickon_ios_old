//
//  NewWordAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

struct NewWordAssembler {
    
    static let shr = NewWordAssembler()
    
    let assembler: Assembler
    
    init() {
        self.assembler = Assembler(container: DI.shr.appContainer)
        self.assembler.apply(assemblies: [HomeAssembler()])
    }
}

extension ObjectScope {
    static let newWordScopeObject = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "newWordObjectScope",
        parent: ObjectScope.mainObjectScope
    )
}
