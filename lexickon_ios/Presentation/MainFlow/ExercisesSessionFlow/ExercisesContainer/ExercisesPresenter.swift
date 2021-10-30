//
//  ExercisesPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.10.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver

final class ExercisesPresenter {
    
    struct Input {
        
    }
    
    @Injected private var exercisesInteractor: ExercisesInteractorProtocol
    
    struct Output {
        let currentSession: ExercisesSessionEntity?
    }
    
    func configure(input: Input) -> Output {
        
        let currentSession = exercisesInteractor.currentSession
        
        return Output(currentSession: currentSession)
    }
}
