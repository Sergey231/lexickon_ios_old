//
//  AppAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 4/29/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerAuthorisationObjects()
        registerMainObjects()
        registerProfileObjects()
        registerNewWordObjects()
        registerWordCardObjects()
        registerExercisesObjects()
    }
}
