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
    
    public func configure() -> Single<UserEntity> {
        let stubUser = UserEntity(
            name: "name",
            email: "email"
        )
        return .just(stubUser)
    }
}

