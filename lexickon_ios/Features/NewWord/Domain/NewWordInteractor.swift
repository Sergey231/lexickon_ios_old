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
import ConfigsRepository


final class NewWordInteractor: NewWordInteractorProtocol {
    
    @Injected private var translationRepository: TranslationRepositoryProtocol
    @Injected private var configsRepository: ConfigsRepositoryProtocol
    
    func translate(_ word: String) -> Single<TranslationResultsDTO> {
        translateByYandexDictionary(word)
    }
    
    private func translateByYandexDictionary(_ text: String) -> Single<TranslationResultsDTO> {
        
        let yandexDictionaryKey = "dict.1.1.20210109T085821Z.0973a0ee9ceeb5aa.350f617168f4b67d8695b278e6efb78cb2b3c296"
        
        return translationRepository.translateByYandexDictionary(YandexDictionaryApiRequestDTO(
            key: yandexDictionaryKey,
            lang: (.en,.ru),
            text: text
        ))
        .map {
            let translations = $0.def.first?.tr ?? []
            return TranslationResultsDTO(
            textForTranslate: text,
                translations: translations.map { tr in
                    print(tr)
                    return TranslationResultsDTO.TranslationItem(
                        translation: tr.text,
                        pos: .unknown,
                        gender: .unknown
                    )
                }
        )}
    }
    
    private func translateByRapidApiGoogleTranslate(_ text: String) -> Single<TranslationResultsDTO> {
       
        let rapidApiKey = configsRepository.object(forKey: .rapidApiGoogleTranslateKey) ?? ""
        let rapidApiHost = configsRepository.object(forKey: .rapidApiGoogleTranslateHost) ?? ""
        
        let input = RapidApiGoogleTranslateRequestDTO(
            text: text,
            rapidApiKey: rapidApiKey,
            rapidApiHost: rapidApiHost,
            targetLanguage: "ru",
            sourceLanguage: "en"
        )
        
        return translationRepository.translateByRapidApiGoogleTranslate(input)
            .map {
                TranslationResultsDTO(
                    textForTranslate: text,
                    translations: [TranslationResultsDTO.TranslationItem(
                        translation: $0.data.translation,
                        pos: .unknown,
                        gender: .unknown
                    )]
                )
            }
    }
}
