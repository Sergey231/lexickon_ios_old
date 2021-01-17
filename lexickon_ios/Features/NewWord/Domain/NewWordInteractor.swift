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
import TranslationRepository

final class NewWordInteractor: NewWordInteractorProtocol {
    
    @Injected private var translationRepository: TranslationRepositoryProtocol
    @Injected private var configsRepository: ConfigsRepositoryProtocol
    
    func translate(_ text: String) -> Single<TranslationResultsDTO> {
        let requestDTO = TranslationRequestDTO(
            text: text,
            targetLanguage: .ru,
            sourceLanguage: .en
        )
        return translateByMicrosoftTranslate(requestDTO)
    }
    
    private func translateByYandexDictionary(_ dto: TranslationRequestDTO) -> Single<TranslationResultsDTO> {
        
        let yandexDictionaryKey = "dict.1.1.20210109T085821Z.0973a0ee9ceeb5aa.350f617168f4b67d8695b278e6efb78cb2b3c296"
        
        return translationRepository.translateByYandexDictionary(YandexDictionaryApiRequestDTO(
            dto: dto,
            key: yandexDictionaryKey
        ))
        .map {
            let translations = $0.def.first?.tr ?? []
            return TranslationResultsDTO(
                textForTranslate: dto.text,
                translations: translations.map { tr in
                    TranslationResultsDTO.TranslationItem(
                        text: dto.text,
                        translation: tr.text,
                        pos: .unknown,
                        gender: .unknown
                    )
                }
            )}
    }
    
    private func translateByRapidApiGoogleTranslate(_ dto: TranslationRequestDTO) -> Single<TranslationResultsDTO> {
        
        let rapidApiKey = configsRepository.object(forKey: .rapidApiGoogleTranslateKey) ?? ""
        let rapidApiHost = configsRepository.object(forKey: .rapidApiGoogleTranslateHost) ?? ""
        
        let request = RapidApiGoogleTranslateRequestDTO(
            dto: dto,
            rapidApiKey: rapidApiKey,
            rapidApiHost: rapidApiHost
        )
        
        return translationRepository.translateByRapidApiGoogleTranslate(request)
            .map {
                TranslationResultsDTO(
                    textForTranslate: request.dto.text,
                    translations: [TranslationResultsDTO.TranslationItem(
                        text: request.dto.text,
                        translation: $0.data.translation,
                        pos: .unknown,
                        gender: .unknown
                    )]
                )
            }
    }
    
    private func translateByMicrosoftTranslate(_ dto: TranslationRequestDTO) -> Single<TranslationResultsDTO> {
        
        let key = "ff3b39475f4a41b8ae887b03deb093dd"
        let region = "northeurope"
        let request = MicrosoftTranslatorRequestDTO(
            dto: dto,
            subscriptionKey: key,
            subscriptionRegion: region
        ) 
        
        return translationRepository.translateByMicrosoftTranslate(request)
            .map {
                TranslationResultsDTO(
                    textForTranslate: request.dto.text,
                    translations: $0.translations.map {
                        TranslationResultsDTO.TranslationItem(
                            text: request.dto.text,
                            translation: $0.text,
                            pos: .unknown,
                            gender: .unknown
                        )
                    }
                )
            }
    }
}
