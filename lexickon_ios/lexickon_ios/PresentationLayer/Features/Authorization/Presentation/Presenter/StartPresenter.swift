//
//  StartPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Foundation
import XCoordinator
import Combine

final class StartPresenter: PresenterType {
    
    struct Input {
        let beginButtonTapped: AnyPublisher<Void, Never>
        let iAmHaveAccountButtonTapped: AnyPublisher<Void, Never>
        let createAccountButtonTapped: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let cancellableSet: Set<AnyCancellable>
    }
    
    var authorizationRouter: UnownedRouter<AuthorizationRoute>?
    
    func setRouter(router: UnownedRouter<AuthorizationRoute>?) {
        self.authorizationRouter = router
    }
    
    func configure(input: Input) -> Output {
        
        var cancellableSet = Set<AnyCancellable>()
        
        input.beginButtonTapped.sink { [weak self] _ in
            self?.authorizationRouter?.trigger(.begin)
        }.store(in: &cancellableSet)
        
        input.iAmHaveAccountButtonTapped.sink { [weak self] _ in
            self?.authorizationRouter?.trigger(.login)
        }.store(in: &cancellableSet)
        
        input.createAccountButtonTapped.sink { [weak self] _ in
            self?.authorizationRouter?.trigger(.registrate)
        }.store(in: &cancellableSet)
        
        return Output(cancellableSet: cancellableSet)
    }
}
