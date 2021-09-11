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
    let exercisesSet: [ExerciseEntity]
    
    public var currentExercise: ExerciseEntity {
        exercisesSet.first ?? .wordView
    }
    
    public var difficultyRating: Int {
        // Тут нужен будет не тривиальный алгоритм определения сложности слова, по колличеству букв, сложных букво сочитаный
        10
    }
    
    public init(
        word: WordEntity,
        exercisesSet: [ExerciseEntity]
    ) {
        self.word = word
        self.exercisesSet = exercisesSet
    }
}

public struct ExercisesSessionEntity {
    
    private var currentWord: SesstionWordEntity? = nil
    private let words: [WordEntity]
    
    public var sessionWords: [SesstionWordEntity] = []
    public let exercises: [ExerciseEntity]
    
    public var currentState: (SesstionWordEntity, ExerciseEntity)? {
        guard
            let currentWord = self.currentWord
        else {
            return nil
        }
        return (currentWord, currentWord.currentExercise)
    }
    
    init(
        words: [WordEntity],
        exercises: [ExerciseEntity]
    ) {
        self.words = words
        self.exercises = exercises
    }
}
