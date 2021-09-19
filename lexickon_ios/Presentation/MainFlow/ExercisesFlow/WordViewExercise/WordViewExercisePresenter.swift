//
//  WordViewExercisePresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 20.08.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver
import LXUIKit

final class WordViewExercisePresenter {
    
    @Injected var exercisesInteracor: ExercisesInteractorProtocol
    
    struct Input {
        let exerciseDidDone: Signal<Void>
    }
    
    struct Output {
      
    }
    
    func configure(input: Input) -> Output {
        
        guard
            let session = exercisesInteracor.currentSession,
            let currentSessionWord = session.currentSessionWord
        else {
            print("👨🏻 ❌ With current Exercise Session is wrong!")
            return Output()
        }
        
        input.exerciseDidDone.debug("👨🏻")
            .flatMap { _ -> Signal<ExercisesSessionEntity.ExerciseType> in
                session.word(currentSessionWord, isPassedInExercise: .wordView)
                    .map { $0.exercise }
                    .asSignal(onErrorRecover: { error -> Signal<ExercisesSessionEntity.ExerciseType> in
                        print("👨🏻 ❌ With current Exercise Session is wrong!")
                        return .just(.none)
                    })
            }
        
        return Output()
    }
}
