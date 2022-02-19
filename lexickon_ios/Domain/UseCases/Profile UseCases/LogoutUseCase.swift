//
//  LogoutUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 16.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class LogoutUseCase {
    
    @Injected var authTokenRepository: AuthTokenRepositoryProtocol
    
    public func configure() -> Single<Void> {
        let didLogout = authTokenRepository.erasе()
        return didLogout
    }
}
