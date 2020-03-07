//
//  AuthorizationAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 16.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

struct AuthorizationAssembler {
    
    static let shr = AuthorizationAssembler()
    
    let assembler: Assembler
    
    init() {
        self.assembler = Assembler(container: DI.shr.appContainer)
        self.assembler.apply(assemblies: [
            StartAssembler(),
            RegistrationAssembler(),
            LoginAssembler()
        ])
    }
}
