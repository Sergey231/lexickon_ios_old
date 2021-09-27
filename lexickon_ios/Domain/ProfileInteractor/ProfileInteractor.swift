//
//  ProfileInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import Resolver
// import AuthTokenRepository
// import UserRepository

struct ProfileInteractor: ProfileInteractorProtocol {
    
    @Injected var authTokenRepository: AuthTokenRepositoryProtocol
    @Injected var userRepository: UserRepositoryProtocol
    
    func logout() -> Single<Void> {
        authTokenRepository.erasе()
    }
    
    public var user: UserEntity {
        let userEntiry = UserEntity(
            name: .just("Name"),
            email: .just("email@test.ru")
        )
        return userEntiry
    }
}
