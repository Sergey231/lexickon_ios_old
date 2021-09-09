//
//  ExercisesSessionEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonStateEntity

public struct ExercisesSessionEntity {
    
    private var currentWord: WordEntity? = nil
    private var currentExercises: ExerciseEntity = .wordView
    
    public let words: [WordEntity]
    public let exercises: [ExerciseEntity]
    
    public var currentState: (WordEntity, ExerciseEntity)? {
        guard
            let currentWord = self.currentWord
        else {
            return nil
        }
        return (currentWord, currentExercises)
    }
    
    init(
        words: [WordEntity],
        exercises: [ExerciseEntity]
    ) {
        self.words = words
        self.exercises = exercises
    }
}
