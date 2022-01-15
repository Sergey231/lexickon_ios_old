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
    
    public struct Output {
        let didRegistred: Single<Void>
    }
    
    public func configure(_ input: Input) -> Output {
        
        let userCreateObject = LxUserCreate(
            email: input.email,
            password: input.password
        )
        
        let didRegistred = userRepository.createUser(with: userCreateObject)
            .map { _ in () }
        
        return Output(didRegistred: didRegistred)
    }
}
