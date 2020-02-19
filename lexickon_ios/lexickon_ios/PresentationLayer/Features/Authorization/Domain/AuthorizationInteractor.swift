//
//  AuthorizationInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

protocol AuthorizationInteractorProtocol {
    
    func registrate(name: String, email: String, password: String)
    func login(login: String, password: String)
    func restorePassword(login: String)
}

final class AuthorizationInteractor {
    
    let authRepository: AuthorizationRepository
    
    init(authRepository: AuthorizationRepository) {
        self.authRepository = authRepository
    }
}
