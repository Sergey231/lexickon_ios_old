//
//  ExercisesSessionEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonStateEntity
import RxSwift

public class ExercisesSessionEntity {
    
    public enum ExerciseType {
        case wordView
        case none
    }
    
    public class SessionWord {
        
        public var word: WordEntity
        public var notPassedExercises: [ExerciseType]
        
        public var currentExercise: ExerciseType {
            notPassedExercises.first ?? .wordView
        }
        
        public var difficultyRating: Int {
            // Тут нужен будет не тривиальный алгоритм определения сложности слова, по колличеству букв, сложных букво сочитаный
            10
        }
        
        public init(
            word: WordEntity,
            exercisesForThisSession: [ExerciseType]
        ) {
            self.word = word
            self.notPassedExercises = exercisesForThisSession
        }
        
        public func exerciseDidPass(_ exercise: ExerciseType) {
            _ = notPassedExercises.remove { $0 == exercise }
        }
    }

    
    public struct NextSessionItem {
        public let word: SessionWord
        public let exercise: ExerciseType
    }
    
    public func word(
        _ word: SessionWord,
        isPassedInExercise: ExerciseType
    ) -> Observable<NextSessionItem> {
        
        return .empty()
    }
    
    public var currentSessionWord: SessionWord? {
        sessionWords.last
    }
    
    public var nextSessionWord: SessionWord? {
        sessionWords.first
    }
    
    public var sessionWords: [SessionWord] = []
    
    init(
        words: [WordEntity],
        exercises: [ExerciseType] = [.wordView]
    ) {
        convertWordEntityToSesstionWord(
            words: words,
            exercises: exercises
        )
    }
    
    private func convertWordEntityToSesstionWord(
        words: [WordEntity],
        exercises: [ExerciseType]
    ) {
        sessionWords = words.map {
            SessionWord(
                word: $0,
                exercisesForThisSession: exercises
            )
        }
    }
}
