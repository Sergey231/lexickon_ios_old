//
//  ExercisesSessionEntity.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import LexickonStateEntity

public class ExercisesSessionEntity {
    
    public var currentSessionWord: SesstionWordEntity? = nil
    public var sessionWords: [SesstionWordEntity] = []
    
    init(
        words: [WordEntity],
        exercises: [ExerciseEntity] = [.wordView]
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
