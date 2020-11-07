//
//  WordInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift

final class MainInteractor: MainInteractorProtocol {
    
    let wordRepository: WordRepositoryProtocol
    
    init(wordRepository: WordRepositoryProtocol) {
        self.wordRepository = wordRepository
    }
    
    func words(per: Int, page: Int) -> Single<PageObject<WordListObject>> {
        return wordRepository.words(per: per, page: page)
    }
}
