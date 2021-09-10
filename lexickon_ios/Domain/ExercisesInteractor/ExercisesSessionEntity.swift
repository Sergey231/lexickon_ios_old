//
//  ExercisesSessionEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonStateEntity

public struct SesstionWordEntity {
    
}

public struct ExercisesSessionEntity {
    
    private var currentWord: SesstionWordEntity? = nil
    private var currentExercises: ExerciseEntity = .wordView
    
    public let words: [SesstionWordEntity]
    public let exercises: [ExerciseEntity]
    
    public var currentState: (SesstionWordEntity, ExerciseEntity)? {
        guard
            let currentWord = self.currentWord
        else {
            return nil
        }
        return (currentWord, currentExercises)
    }
    
    init(
        words: [SesstionWordEntity],
        exercises: [ExerciseEntity]
    ) {
        self.words = words
        self.exercises = exercises
    }
}
