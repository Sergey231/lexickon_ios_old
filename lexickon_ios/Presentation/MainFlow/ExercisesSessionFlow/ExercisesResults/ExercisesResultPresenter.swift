//
//  ExercisesResultsPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.10.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver

final class ExercisesResultPresenter {
    
    struct Input {
        let submitButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let sessionDidFinish: Signal<Void>
    }
    
    @Injected private var syncExerciseSessionUseCase: SyncExerciseSessionUseCase
    @Injected private var getExerciseSessionUseCase: GetExerciseSessionUseCase
    
    func configure(input: Input) -> Output {
        
        let sessionDidFinish = input.submitButtonDidTap
            .flatMap { [weak self] _ in
                let session = self?.getExerciseSessionUseCase.configure()
                return self?.syncExerciseSessionUseCase.configure(
                    SyncExerciseSessionUseCase.Input(session: session)
                )
                    .asSignal(onErrorSignalWith: .empty())
            }
        
        return Output(sessionDidFinish: sessionDidFinish)
    }
}
