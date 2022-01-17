//
//  AddNewWordsUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 17.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class AddNewWordsUseCase {
    
    @Injected private var wordRepository: WordsRepositoryProtocol
    
    public struct Input {
        let newWords: [TranslationResultsDTO.Translation]
    }
    
    public struct Output {
        let wordsDidAdded: Single<Void>
    }
    
    public func configure(_ input: Input) -> Output {
        
        let wordCreateModels = input.newWords
            .map {
                LxWordCreate(
                    studyWord: $0.text,
                    translates: [$0.translation],
                    image: ""
                )
            }
        
        let wordsDidAdded = wordRepository.add(wordCreateModels)
            .map { _ in () }
        
        return Output(wordsDidAdded: wordsDidAdded)
    }
}
