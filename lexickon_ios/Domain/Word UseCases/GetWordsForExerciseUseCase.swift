//
//  GetWordsForExerciseUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class GetWordsForExerciseUseCase {
    
    @Injected private var wordsRepository: WordsRepositoryProtocol
    
    public struct Input {
        let count: Int
    }
    
    public struct Output {
        let wordsForExercise: Single<[WordEntity]>
    }
    
    public func configure(_ input: Input) -> Output {
        
        let wordsForExercise = wordsRepository.words(per: input.count, page: 1)
            .map { page -> [WordEntity] in
                page.items.compactMap {
                    let word = WordEntity(withLxWordList: $0)
                    return word.studyState != .waiting ? word : nil
                }
            }
        
        return Output(wordsForExercise: wordsForExercise)
    }
}
