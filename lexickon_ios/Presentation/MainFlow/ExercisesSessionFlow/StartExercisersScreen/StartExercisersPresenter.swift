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
    
    @Injected private var getWordsForExerciseUseCase: GetWordsForExerciseUseCase
    @Injected private var creatExerciseSessionUseCase: CreatExerciseSessionUseCase
    @Injected private var getExerciseSessionUseCase: GetExerciseSessionUseCase
    
    struct Input {
        
    }
    
    struct Output {
        let execisesSessionCreated: Signal<ExercisesSessionEntity>
    }
    
    func configure(input: Input) -> Output {
        
        if let session = getExerciseSessionUseCase.configure() {
            return Output(execisesSessionCreated: .just(session))
        }
        
        let wordsForExerceses = getWordsForExerciseUseCase.configure(GetWordsForExerciseUseCase.Input(count: 5))
            .wordsForExercise
            .asSignal { error in
                print("❌ StartExercisesPresenter: \(error.localizedDescription)")
                return .just([])
            }
        
        let execisesSessionEntity = wordsForExerceses
            .flatMap { [unowned self] words in
                creatExerciseSessionUseCase.configure(CreatExerciseSessionUseCase.Input(words: words))
                    .asSignal { error in
                        print("❌ StartExercisesPresenter: \(error.localizedDescription)")
                        return .empty()
                    }
            }
        
        return Output(execisesSessionCreated: execisesSessionEntity)
    }
}
