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
import WordsRepository

final class NewWordInteractor: NewWordInteractorProtocol {
    
    @Injected private var translationRepository: TranslationRepositoryProtocol
    @Injected private var configsRepository: ConfigsRepositoryProtocol
    @Injected private var wordRepository: WordsRepositoryProtocol
    
    func translate(_ text: String) -> Single<TranslationResultsDTO> {
        let requestDTO = TranslationRequestDTO(
            text: text,
            targetLanguage: .ru,
            sourceLanguage: .en
        )
        return translateByMicrosoftDictionary(requestDTO)
    }
    
    public func addWord(_ word: TranslationResultsDTO.Translation) -> Single<Void> {
        let wordCreateModel = LxWordCreate(
            studyWord: word.text,
            translates: [word.translation],
            image: ""
        )
        return wordRepository.add(wordCreateModel)
            .map { _ in () }
    }
    
    private func translateByYandexDictionary(_ dto: TranslationRequestDTO) -> Single<TranslationResultsDTO> {
        
        let yandexDictionaryKey = configsRepository.object(forKey: .yandexTranslationAPIKey)!
        
        return translationRepository.translateByYandexDictionary(YandexDictionaryApiRequestDTO(
            dto: dto,
            key: yandexDictionaryKey
        ))
        .map {
            let translations = $0.def.first?.tr ?? []
            return TranslationResultsDTO(
                textForTranslate: dto.text,
                translations: translations.map { tr in
                    TranslationResultsDTO.Translation(
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
                    translations: [TranslationResultsDTO.Translation(
                        text: request.dto.text,
                        translation: $0.data.translation,
                        pos: .unknown,
                        gender: .unknown
                    )]
                )
            }
    }
    
    private func translateByMicrosoftTranslate(_ dto: TranslationRequestDTO) -> Single<TranslationResultsDTO> {
        
        let key = configsRepository.object(forKey: .microsoftTranslationAPIKey)!
        let region = configsRepository.object(forKey: .microsoftTranslationAPIRegion)!
        let baseUrl = configsRepository.object(forKey: .microsoftTranslationAPIBaseUrl)!
        
        let request = MicrosoftTranslationRequestDTO(
            baseUrl: baseUrl,
            dto: dto,
            subscriptionKey: key,
            subscriptionRegion: region
        ) 
        
        return translationRepository.translateByMicrosoftTranslate(request)
            .map {
                TranslationResultsDTO(
                    textForTranslate: request.dto.text,
                    translations: $0.translations.map {
                        TranslationResultsDTO.Translation(
                            text: request.dto.text,
                            translation: $0.text,
                            pos: .unknown,
                            gender: .unknown
                        )
                    }
                )
            }
    }
    
    private func translateByMicrosoftDictionary(_ dto: TranslationRequestDTO) -> Single<TranslationResultsDTO> {
        
        let key = configsRepository.object(forKey: .microsoftTranslationAPIKey)!
        let region = configsRepository.object(forKey: .microsoftTranslationAPIRegion)!
        let baseUrl = configsRepository.object(forKey: .microsoftTranslationAPIBaseUrl)!
        
        let request = MicrosoftTranslationRequestDTO(
            baseUrl: baseUrl,
            dto: dto,
            subscriptionKey: key,
            subscriptionRegion: region
        )
        
        return translationRepository.translateByMicrosoftDictionary(request)
            .map {
                TranslationResultsDTO(
                    textForTranslate: request.dto.text,
                    translations: $0.translations.map {
                        TranslationResultsDTO.Translation(
                            text: request.dto.text,
                            translation: $0.displayTarget,
                            pos: .unknown,
                            gender: .unknown
                        )
                    }
                )
            }
    }
}
