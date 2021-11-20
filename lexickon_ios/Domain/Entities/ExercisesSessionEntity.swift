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
    
    public var sessionWords: [SessionWord] = []
    private let sessionProgressRelay = BehaviorRelay<CGFloat>(value: 0)
    private var entireSessionProgress: CGFloat = 0
    private var currentSessionProgress: CGFloat = 0
    private var sessionItem: NextSessionItem?
    
    public var currentSessionWord: SessionWord? {
        sessionWords.last
    }
    
    public var currentSessionItem: NextSessionItem {
        guard let sessionItem = sessionItem else {
            let initSessionItem = NextSessionItem(
                word: currentSessionWord,
                exercise: currentSessionWord?.notPassedExercises.last ?? .none
            )
            self.sessionItem = initSessionItem
            return initSessionItem
        }
        return sessionItem
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
        self.entireSessionProgress = sessionWords.reduce(CGFloat(0), { partialResult, word in
            partialResult + CGFloat(word.notPassedExercises.count)
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
        culcSessionProgress()
        
        // Проверяем есть ли еще слова в сессии именно с этим видом упражнений
        if let nextSessionWord = nextSessionWord(with: isPassedInExercise) {
            // Деллаем поле currentSessionItem всегда актуальное
            let sessionItem = NextSessionItem(
                word: nextSessionWord,
                exercise: isPassedInExercise
            )
            self.sessionItem = sessionItem
            return sessionItem
        }
        
        // Деллаем поле currentSessionItem всегда актуальное
        let sessionItem = NextSessionItem(word: nil, exercise: .none)
        self.sessionItem = sessionItem
        return sessionItem
    }
    
    private func culcSessionProgress() {
        currentSessionProgress = sessionWords.reduce(CGFloat(0), { partialResult, word in
            partialResult + CGFloat(word.notPassedExercises.count)
        })
        
        let persent = entireSessionProgress / currentSessionProgress
        
        sessionProgressRelay.accept(persent)
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

// MARK: ExerciseType

public extension ExercisesSessionEntity {
    enum ExerciseType {
        case wordView
        case none
    }
}

// MARK: NextSessionItem

public extension ExercisesSessionEntity {
    struct NextSessionItem {
        public let word: SessionWord?
        public let exercise: ExerciseType
        
        public static var emptyItem: Self {
            NextSessionItem(word: nil, exercise: .none)
        }
    }
}

// MARK: SessionWord

public extension ExercisesSessionEntity {
    class SessionWord: Hashable {
        
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
}
