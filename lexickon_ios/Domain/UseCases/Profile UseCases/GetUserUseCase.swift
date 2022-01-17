//
//  GetUserUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 16.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class GetUserUseCase {
    
    @Injected var userRepository: UserRepositoryProtocol
    
    public struct Output {
        let user: Single<UserEntity>
    }
    
    public func configure() -> Output {
        let stubUser = UserEntity(
            name: "name",
            email: "email"
        )
        return Output(user: .just(stubUser))
    }
}

