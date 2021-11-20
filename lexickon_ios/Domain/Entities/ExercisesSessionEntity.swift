//
//  ExercisesSessionEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public class ExercisesSessionEntity {
    
    public enum ExerciseType {
        case wordView
        case none
    }
    
    public class SessionWord: Hashable {
        
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
        
        fileprivate func exerciseDidPass(_ exercise: ExerciseType) {
            _ = notPassedExercises.remove { $0 == exercise }
        }
        
        public static func == (
            lhs: ExercisesSessionEntity.SessionWord,
            rhs: ExercisesSessionEntity.SessionWord
        ) -> Bool {
            return lhs.word.studyWord == rhs.word.studyWord
            && lhs.word.translates.first == rhs.word.translates.first
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(word.studyWord)
            hasher.combine(word.translates.first)
        }
    }

    
    public struct NextSessionItem {
        public let word: SessionWord?
        public let exercise: ExerciseType
        
        public static var zero: Self {
            NextSessionItem(word: nil, exercise: .none)
        }
    }
    
    public var sessionWords: [SessionWord] = []
    private let sessionProgressRelay = BehaviorRelay<CGFloat>(value: 0)
    private var entireSessionProgress: Int = 0
    private var currentSessionProgress: Int = 0
    
    public var currentSessionWord: SessionWord? {
        sessionWords.last
    }
    
    public var sessionProgress: Driver<CGFloat> {
        // 100% прогересса сессии = количество слов * количество убражнений
        sessionProgressRelay.asDriver()
    }
    
    init(
        words: [WordEntity],
        exercises: [ExerciseType] = [.wordView]
    ) {
        convertWordEntityToSesstionWord(
            words: words,
            exercises: exercises
        )
        self.entireSessionProgress = sessionWords.reduce(0, { partialResult, word in
            partialResult + word.notPassedExercises.count
        })
    }
    
    // Помечаем слово как прошедшее, конкретное упражнение и повышаем ему study rating
    public func word(
        _ word: SessionWord?,
        isPassedInExercise: ExerciseType
    ) -> NextSessionItem {
       
        // Удаляем упражнение из слова.
        word?.exerciseDidPass(isPassedInExercise)
        
        // Перещитываем currentSessionProgress
        currentSessionProgress = sessionWords.reduce(0, { partialResult, word in
            partialResult + word.notPassedExercises.count
        })
        
        print("👨🏻 \(currentSessionProgress)")
        
        // Проверяем есть ли еще слова в сессии именно с этим видом упражнений
        if let nextSessionWord = nextSessionWord(with: isPassedInExercise) {
            return NextSessionItem(
                word: nextSessionWord,
                exercise: isPassedInExercise
            )
        }
        
        return NextSessionItem(word: nil, exercise: .none)
    }
    
    private func nextSessionWord(with exerciseType: ExerciseType = .wordView) -> SessionWord? {
        // Тут нужно будет добавить рандом
        sessionWords.first { sesstionWord in
            sesstionWord.notPassedExercises.contains(exerciseType)
        }
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
