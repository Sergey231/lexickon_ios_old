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
    
    @Injected private var translationRepository: TranslationRepositoryProtocol
    @Injected private var keyValueRepository: KeyValueRepositoryProtocol
    
    func translate(_ word: String) -> Single<TranslationResultsDTO> {
        
        let rapidApiKey = keyValueRepository.objectFromConfigs(forKey: .rapidApiGoogleTranslateKey) ?? ""
        let rapidApiHost = keyValueRepository.objectFromConfigs(forKey: .rapidApiGoogleTranslateHost) ?? ""
        
        let input = RapidApiGoogleTranslateRequestDTO(
            text: word,
            rapidApiKey: rapidApiKey,
            rapidApiHost: rapidApiHost,
            targetLanguage: "ru",
            sourceLanguage: "en"
        )
        
        return translationRepository.translate(input)
    }
}
