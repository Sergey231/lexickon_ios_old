//
//  AuthorizationInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

protocol AuthorizationInteractorProtocol {
    
}

final class AuthorizationInteractor {
    
    let authRepository: AuthorizationRepository
    
    init(authRepository: AuthorizationRepository) {
        self.authRepository = authRepository
    }
}
