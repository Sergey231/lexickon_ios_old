//
//  ProfileInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import Resolver
import AuthTokenRepository

struct ProfileInteractor: ProfileInteractorProtocol {
    
    @Injected var authTokenRepository: AuthTokenRepositoryProtocol
    
    func logout() -> Single<Void> {
        return authTokenRepository.erasе()
    }
}


