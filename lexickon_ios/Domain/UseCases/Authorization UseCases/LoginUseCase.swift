//
//  LoginUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 14.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class LoginUseCase {
    
    @Injected var authTokenRepository: AuthTokenRepositoryProtocol
    
    public struct Input {
        let login: String
        let password: String
    }
    
    public func configure(_ input: Input) -> Single<Void> {
        
        let userCredantions = LxUserCreate(
            email: input.login,
            password: input.password
        )
        
        let didLogin = authTokenRepository.get(with: userCredantions)
            .map { _ in () }
        
        return didLogin
    }
}
