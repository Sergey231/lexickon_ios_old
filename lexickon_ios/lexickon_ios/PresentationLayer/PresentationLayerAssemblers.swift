//
//  PresentationAssembler.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 19.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import Swinject

struct PresentationLayerAssemblers {
    
    static var assemblers: [Assembly] {
        return [
            LoginAssembler(),
            RegistrationAssembler(),
            StartAssembler(),
            MainAssembler(),
            IntroAssembler()
        ]
    }
}
