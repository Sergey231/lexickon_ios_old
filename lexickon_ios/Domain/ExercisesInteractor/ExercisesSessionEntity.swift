//
//  ExercisesSessionEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonStateEntity

public struct SesstionWordEntity {
    public var word: WordEntity
    private var exercises: [ExerciseEntity]
    
    public var currentExercise: ExerciseEntity {
        exercises.first ?? .wordView
    }
    
    public var difficultyRating: Int {
        // Тут нужен будет не тривиальный алгоритм определения сложности слова, по колличеству букв, сложных букво сочитаный
        10
    }
    
    public init(
        word: WordEntity,
        exercises: [ExerciseEntity]
    ) {
        self.word = word
        self.exercises = exercises
    }
}

public class ExercisesSessionEntity {
    
    public var currentSessionWord: SesstionWordEntity? = nil
    public var sessionWords: [SesstionWordEntity] = []
    
    init(
        words: [WordEntity],
        exercises: [ExerciseEntity]
    ) {
        convertWordEntityToSesstionWord(
            words: words,
            exercises: exercises
        )
    }
    
    private func convertWordEntityToSesstionWord(
        words: [WordEntity],
        exercises: [ExerciseEntity]
    ) {
        sessionWords = words.map {
            SesstionWordEntity(
                word: $0,
                exercises: exercises
            )
        }
    }
}
