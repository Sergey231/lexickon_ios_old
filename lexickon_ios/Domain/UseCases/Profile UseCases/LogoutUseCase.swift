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
    
    public struct Output {
        let didLogout: Single<Void>
    }
    
    public func configure() -> Output {
        let didLogout = authTokenRepository.erasе()
        return Output(didLogout: didLogout)
    }
}
