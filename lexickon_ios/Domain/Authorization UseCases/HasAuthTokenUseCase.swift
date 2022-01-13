//
//  HasAuthTokenUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 13.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class HasAuthTokenUseCase {
    
    @Injected var authTokenRepository: AuthTokenRepositoryProtocol
    
    public struct Output {
        let hasAuthToken: Single<Bool>
    }
    
    public func configure() -> Output {
        let hasAuthToken = authTokenRepository.cach
            .map { _ -> Bool in true }
            .catchAndReturn(false)
        return Output(hasAuthToken: hasAuthToken)
    }
}
