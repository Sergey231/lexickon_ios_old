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
        let exerciseDidDone: Signal<Void>
    }
    
    @Injected private var exercisesInteractor: ExercisesInteractorProtocol
    
    struct Output {
        let currentSession: ExercisesSessionEntity?
    }
    
    func configure(input: Input) -> Output {
        
        let currentSession = exercisesInteractor.currentSession
        
        let nextExerciseType = input.exerciseDidDone
            .map { _ -> ExercisesSessionEntity.ExerciseType in
                currentSession.word(currentSession?.currentSessionWord, isPassedInExercise: .wordView)
                    .exercise
            }
            .asSignal(onErrorRecover: { error -> Signal<ExercisesSessionEntity.ExerciseType> in
                print("👨🏻 ❌ Current Exercise Session is wrong!")
                return .just(.none)
            })
        
        return Output(currentSession: currentSession)
    }
}
