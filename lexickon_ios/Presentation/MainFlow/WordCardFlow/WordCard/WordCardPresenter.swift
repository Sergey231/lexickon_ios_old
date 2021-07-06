//
//  WordCardPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.06.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import Resolver
import LexickonApi
import LexickonStateEntity

final class WordCardPresenter {
    
    struct Input {
        let word: WordEntity
    }
    
    struct Output {
        let studySate: Driver<LxStudyState>
        let studyWord: String
        let translation: String
        let wordRatingLevel: Driver<Int>
    }
    
    func configure(input: Input) -> Output {
        
        return Output(
            studySate: .just(input.word.testStudyState),
            studyWord: input.word.studyWord,
            translation: input.word.translates.first ?? "",
            wordRatingLevel: .just(10)
        )
    }
}
