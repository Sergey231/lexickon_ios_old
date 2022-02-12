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
    @Injected private var exerciseSessionRepository: ExerciseSessionRepositoryProtocol
    
    public struct Input {
        let words: [WordEntity]
    }
    
    public struct Output {
        let session: Single<ExercisesSessionEntity>
    }
    
    public func configure(_ input: Input) -> Single<ExercisesSessionEntity> {
        let session = ExercisesSessionEntity(
            words: input.words,
            exercises: [.wordView]
        )
        
        let exercisesSessionEntity = exerciseSessionRepository.saveSession(session: session)
            .map { _ in session }
        
        return exercisesSessionEntity
    }
}

