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
import LXUIKit

final class StartExercisesPresenter {
    
    @Injected private var lexickonStateInteractor: LexickonStateInteractorProtocol
    @Injected private var exercisesInteractor: ExercisesInteractorProtocol
    
    struct Input {
        
    }
    
    struct Output {
        let execisesSessionCreated: Signal<ExercisesSessionEntity>
    }
    
    func configure(input: Input) -> Output {
        
        let wordsForExerceses = lexickonStateInteractor.wordsForExercisesSession(count: 5)
            .asSignal { error in
                print("❌ StartExercisesPresenter: \(error.localizedDescription)")
                return .just([])
            }
        
        let execisesSessionEntity = wordsForExerceses
            .flatMap { [unowned self] words -> Signal<ExercisesSessionEntity> in
                exercisesInteractor.createExerciseSession(with: words)
                    .asSignal { error in
                        print("❌ StartExercisesPresenter: \(error.localizedDescription)")
                        return .empty()
                    }
            }
        
        return Output(execisesSessionCreated: execisesSessionEntity)
    }
}
