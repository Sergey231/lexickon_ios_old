//
//  StartExercisersPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver

final class StartExercisesPresenter {
    
    @Injected private var getWordsForExercise: GetWordsForExerciseUseCase
    @Injected private var creatExerciseSession: CreatExerciseSessionUseCase
    
    struct Input {
        
    }
    
    struct Output {
        let execisesSessionCreated: Signal<ExercisesSessionEntity>
    }
    
    func configure(input: Input) -> Output {
        
        let wordsForExerceses = getWordsForExercise.configure(GetWordsForExerciseUseCase.Input(count: 5))
            .wordsForExercise
            .asSignal { error in
                print("❌ StartExercisesPresenter: \(error.localizedDescription)")
                return .just([])
            }
        
        let execisesSessionEntity = wordsForExerceses
            .map { [unowned self] words -> ExercisesSessionEntity in
                creatExerciseSession.configure(CreatExerciseSessionUseCase.Input(words: words))
                    .session
            }
            .asSignal { error in
                print("❌ StartExercisesPresenter: \(error.localizedDescription)")
                return .empty()
            }
        
        return Output(execisesSessionCreated: execisesSessionEntity)
    }
}
