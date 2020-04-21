//
//  StartPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import Foundation
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
    
    func configure(input: Input) -> Output {
        
        var cancellableSet = Set<AnyCancellable>()
        
        return Output(cancellableSet: cancellableSet)
    }
}
