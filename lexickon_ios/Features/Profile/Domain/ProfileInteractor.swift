//
//  ProfileInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift

struct ProfileInteractor: ProfileInteractorProtocol {
    
    let authTokenRepository: AuthTokenRepositoryProtocol
    
    init(authTokenRepository: AuthTokenRepositoryProtocol) {
        self.authTokenRepository = authTokenRepository
    }
    
    func logout() -> Single<Void> {
        return authTokenRepository.erasе()
    }
}


