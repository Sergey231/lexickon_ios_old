//
//  ExercisesInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 01.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation
import RxSwift
import LexickonApi
import Resolver

public class ExercisesInteractor: ExercisesInteractorProtocol {
    
    @Injected var wordsRepository: WordsRepositoryProtocol
    private var exerciseSession: ExercisesSessionEntity?
    
    public var currentSession: ExercisesSessionEntity? {
        exerciseSession
    }
    
    public func createExerciseSession(with words: [WordEntity]) -> Single<ExercisesSessionEntity> {
        let exercisesSessionEntity = ExercisesSessionEntity(
            words: words,
            exercises: [.wordView]
        )
        exerciseSession = exercisesSessionEntity
        return .just(exercisesSessionEntity)
    }
    
    public func saveCurrentSession() -> Single<Void> {
        let wordsForSave: [LxWordUpdate] = exerciseSession?.sessionWords
            .map {
                return LxWordUpdate.create(with: $0)
            } ?? []
        return wordsRepository.update(words: wordsForSave)
            .map { _ in () }
    }
}

fileprivate extension LxWordUpdate {
    static func create(with sessionWord: ExercisesSessionEntity.SessionWord) -> Self {
        LxWordUpdate(
            id: sessionWord.word.id,
            updatingStudyRatingDate: UInt(sessionWord.word.updatingStudyRatingDate ?? 0),
            studyRating: UInt(sessionWord.word.studyRating)
        )
    }
}
