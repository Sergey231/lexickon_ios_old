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
        let studySate: Driver<StudyState>
    }
    
    func configure(input: Input) -> Output {
        
        return Output(studySate: .just(input.word.testStudyState))
    }
}
