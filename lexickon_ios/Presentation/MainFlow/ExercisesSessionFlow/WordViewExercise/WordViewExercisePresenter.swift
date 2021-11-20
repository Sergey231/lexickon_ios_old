//
//  WordViewExercisePresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 20.08.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver

final class WordViewExercisePresenter {
    
    struct Input {
        let nextSessionItem: ExercisesSessionEntity.NextSessionItem
    }
    
    struct Output {
        let studyWord: String
        let translation: String
    }
    
    func configure(input: Input) -> Output {
        
        guard
            let currentSessionWord = input.nextSessionItem.word
        else {
            print("👨🏻 ❌ Current Exercise Session is wrong!")
            return Output(studyWord: "", translation: "")
        }
        
        return Output(
            studyWord: currentSessionWord.word.studyWord,
            translation: currentSessionWord.word.translates.first ?? ""
        )
    }
}
