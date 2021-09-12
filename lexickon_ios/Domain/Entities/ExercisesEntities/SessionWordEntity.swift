//
//  SessionWordEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonStateEntity

public class SesstionWordEntity {
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
    
    public func exerciseDidPass(_ exercise: ExerciseEntity) {
        _ = exercises.remove { $0 == exercise }
    }
}
