//
//  AuthorizationInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

final class AuthorizationInteractor {
    
    let authRepository: LoginRepository
    
    init(authRepository: LoginRepository) {
        self.authRepository = authRepository
    }
}

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    
    func registrate(name: String, email: String, password: String) {
        <#code#>
    }
    
    func login(login: String, password: String) {
        <#code#>
    }
    
    func restorePassword(login: String) {
        <#code#>
    }
}
