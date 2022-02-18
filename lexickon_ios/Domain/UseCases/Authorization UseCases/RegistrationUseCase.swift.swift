//
//  RegistrationUseCase.swift.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 15.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class RegistrationUseCase {
    
    @Injected var userRepository: UserRepositoryProtocol
    
    public struct Input {
        let name: String
        let email: String
        let password: String
    }
    
    public func configure(_ input: Input) -> Single<Void> {
        
        let userCreateObject = LxUserCreate(
            email: input.email,
            password: input.password
        )
        
        let didRegistred = userRepository.createUser(with: userCreateObject)
            .map { _ in () }
        
        return didRegistred
    }
}
