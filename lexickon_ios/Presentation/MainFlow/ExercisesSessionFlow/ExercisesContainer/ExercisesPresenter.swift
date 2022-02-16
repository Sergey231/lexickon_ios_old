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
    
    @Injected private var getExerciseUseCase: GetExerciseSessionUseCase
    
    struct Output {
        let currentSession: ExercisesSessionEntity?
        let nextSessionItem: Signal<ExercisesSessionEntity.NextSessionItem>
    }
    
    func configure(input: Input) -> Output {
        
        let currentSession = getExerciseUseCase.configure()
        
        let nextExerciseType = input.exerciseDidDone
            .map { _ -> ExercisesSessionEntity.NextSessionItem in
                currentSession?.word(
                    currentSession?.currentSessionItem.word,
                    isPassedInExercise: .wordView
                ) ?? .emptyItem
            }
            .asSignal(onErrorRecover: { error -> Signal<ExercisesSessionEntity.NextSessionItem> in
                print("👨🏻 ❌ Current Exercise Session is wrong!")
                return .just(.emptyItem)
            })
        
        return Output(
            currentSession: currentSession,
            nextSessionItem: nextExerciseType
        )
    }
}
