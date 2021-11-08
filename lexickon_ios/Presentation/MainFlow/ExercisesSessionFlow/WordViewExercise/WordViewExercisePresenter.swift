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
    
    @Injected var exercisesInteracor: ExercisesInteractorProtocol
    
    struct Input {
        
    }
    
    struct Output {
        let studyWord: String
        let translation: String
    }
    
    func configure(input: Input) -> Output {
        
        guard
            let session = exercisesInteracor.currentSession,
            let currentSessionWord = session.currentSessionWord
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
