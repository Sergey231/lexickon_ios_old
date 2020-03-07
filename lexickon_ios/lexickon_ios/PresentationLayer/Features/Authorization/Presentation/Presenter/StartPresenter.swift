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
    
    private var router: UnownedRouter<AuthorizationRoute>?
    
    private var cancellableSet = Set<AnyCancellable>()
    
    func setRouter(router: UnownedRouter<AuthorizationRoute>) {
        self.router = router
    }
    
    func configure(input: Input) {
        
        input.beginButtonTapped.sink { [weak self] _ in
            self?.router?.trigger(.begin)
        }.store(in: &cancellableSet)
        
        input.iAmHaveAccountButtonTapped.sink { _ in
            self.router?.trigger(.login)
        }.store(in: &cancellableSet)
        
        input.createAccountButtonTapped.sink { _ in
            self.router?.trigger(.registrate)
        }.store(in: &cancellableSet)
    }
}
