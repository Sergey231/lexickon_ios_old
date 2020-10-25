//
//  ProfileAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

struct ProfileAssembler {
    
    static let shr = ProfileAssembler()
    
    let assembler: Assembler
    
    init() {
        self.assembler = Assembler(container: DI.shr.appContainer)
        self.assembler.apply(assemblies: [
            ProfileMainScreenAssembler()
        ])
    }
}

extension ObjectScope {
    static let profileScopeObject = ObjectScope(
        storageFactory: PermanentStorage.init,
        description: "profileObjectScope",
        parent: ObjectScope.mainObjectScope
    )
}
