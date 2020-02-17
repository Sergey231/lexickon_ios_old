//
//  AuthorizationAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 16.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

struct AuthorizationAssemblers {
    
    static var assemblers: [Assembly] {
        return [
            LoginAssembler(),
            RegistrationAssembler(),
            StartAssembler()
        ]
    }
}
