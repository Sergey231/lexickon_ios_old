//
//  GetWordsUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class GetWordsUseCase {
    
    public struct Input {
        let per: Int
        let page: Int
    }
    
    public struct Output {
        let words: Single<LxPage<WordEntity>>
    }
    
    @Injected private var wordsRepository: WordsRepositoryProtocol
    
    public func configure(_ input: Input) -> Output {
        
        let words = wordsRepository.words(per: input.per, page: input.page)
            .map { page -> LxPage<WordEntity> in
                
                let metadata = LxPage<WordEntity>.Metadata(
                    page: page.metadata.page,
                    per: page.metadata.per,
                    total: page.metadata.total
                )
                
                let items: [WordEntity] = page.items.map { WordEntity(withLxWordList: $0) }
                
                return LxPage<WordEntity>.init(
                    metadata: metadata,
                    items: items
                )
            }
        
        return Output(words: words)
    }
}
