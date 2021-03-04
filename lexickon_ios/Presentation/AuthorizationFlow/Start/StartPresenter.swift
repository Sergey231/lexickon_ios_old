//
//  StartPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import Resolver

final class StartPresenter {
    
    @Injected var authorisationInteractor: AuthorizationInteractorProtocol
    
    struct Input {
        let beginButtonTapped: Signal<Void>
        let iAmHaveAccountButtonTapped: Signal<Void>
        let createAccountButtonTapped: Signal<Void>
    }
    
    struct Output {
        let isAuthorized: Driver<Bool>
    }
    
    func configure(input: Input) -> Output {
        
        let isAuthorized = authorisationInteractor.hasAuthToken
            .asDriver(onErrorJustReturn: false)
        
        return Output(isAuthorized: isAuthorized)
    }
}
