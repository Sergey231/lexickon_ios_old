//
//  CreatExerciseSessionUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class CreatExerciseSessionUseCase {
    
    @Injected private var wordsRepository: WordsRepositoryProtocol
    
    public struct Input {
        let words: [WordEntity]
    }
    
    public struct Output {
        let session: ExercisesSessionEntity
    }
    
    public func configure(_ input: Input) -> Output {
        let exercisesSessionEntity = ExercisesSessionEntity(
            words: input.words,
            exercises: [.wordView]
        )
        return Output(session: exercisesSessionEntity)
    }
}
