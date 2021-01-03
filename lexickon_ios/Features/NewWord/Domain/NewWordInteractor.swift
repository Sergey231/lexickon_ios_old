//
//  NewWordInteractor.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import LexickonApi
import Resolver

final class NewWordInteractor: NewWordInteractorProtocol {
    
    @Injected var translationRepository: TranslationRepositoryProtocol
    
    func translate(_ word: String) -> Single<TranslationResultsDTO> {
        return translationRepository.translate(word, tl: "ru", sl: "en")
    }
}
