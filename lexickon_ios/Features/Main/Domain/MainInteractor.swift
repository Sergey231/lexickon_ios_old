//
//  WordInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift
import Resolver
import WordsRepository

final class MainInteractor: MainInteractorProtocol {
    
    @Injected var wordRepository: WordsRepositoryProtocol
    
    func words(per: Int, page: Int) -> Single<LxPage<LxWordList>> {
        wordRepository.words(per: per, page: page)
    }
    
    func word(by id: String) -> Single<LxWordGet> {
        wordRepository.word(by: id)
    }
}
