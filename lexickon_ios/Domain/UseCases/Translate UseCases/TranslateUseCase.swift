//
//  TranslateUseCase.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 18.01.2022.
//  Copyright © 2022 Sergey Borovikov. All rights reserved.
//

import RxCocoa
import RxSwift
import Resolver
import LexickonApi

final class TranslateUseCase {
    
    private typealias Translation = TranslationResultsDTO.Translation
    
    @Injected private var translationRepository: TranslationRepositoryProtocol
    @Injected private var configsRepository: ConfigsRepositoryProtocol
    
    public struct Input {
        let text: String
    }
    
    public func configure(_ input: Input) -> Single<TranslationResultsDTO> {
        
        let requestDTO = TranslationRequestDTO(
            text: input.text,
            targetLanguage: .ru,
            sourceLanguage: .en
        )
        
        let translationResult = translateByMicrosoftDictionary(requestDTO)
        
        return translationResult
    }
    
    private func translateByYandexDictionary(_ dto: TranslationRequestDTO) -> Single<TranslationResultsDTO> {
        
        let yandexDictionaryKey = configsRepository.object(forKey: .yandexTranslationAPIKey)!
        
        return translationRepository.translateByYandexDictionary(YandexDictionaryApiRequestDTO(
            dto: dto,
            key: yandexDictionaryKey
        ))
        .map {
            let translations = $0.def.first?.tr ?? []
            let mainTranslation = Translation(
                text: dto.text,
                translation: translations.first?.text ?? "",
                pos: .unknown,
                gender: .unknown
            )
            
            let otherTranslations: [Translation] = translations
                .dropFirst()
                .map {
                    Translation(
                        text: dto.text,
                        translation: $0.text,
                        pos: .unknown,
                        gender: .unknown
                    )
                }
            
            return TranslationResultsDTO(
                textForTranslate: dto.text,
                mainTranslation: mainTranslation,
                otherTranslations: otherTranslations
            )
        }
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
                
                let mainTranslation = Translation(
                    text: request.dto.text,
                    translation: $0.data.translation,
                    pos: .unknown,
                    gender: .unknown
                )
                
                return TranslationResultsDTO(
                    textForTranslate: request.dto.text,
                    mainTranslation: mainTranslation,
                    otherTranslations: []
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
                let firstTranslation: MicrosoftTranslatorResultsDTO.Translation? = $0.translations.first
                let mainTranslation = Translation(
                    text: request.dto.text,
                    translation: firstTranslation?.to ?? "",
                    pos: .unknown,
                    gender: .unknown
                )
                
                let otherTranslations: [Translation] = $0.translations
                    .dropFirst()
                    .map {
                        Translation(
                            text: request.dto.text,
                            translation: $0.to,
                            pos: .unknown,
                            gender: .unknown
                        )
                    }
                
                return TranslationResultsDTO(
                    textForTranslate: request.dto.text,
                    mainTranslation: mainTranslation,
                    otherTranslations: otherTranslations
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
                let firstTranslation: MicrosoftDictionaryResultsDTO.Translation? = $0.translations.first
                let mainTranslation = Translation(
                    text: request.dto.text,
                    translation: firstTranslation?.displayTarget ?? "",
                    pos: firstTranslation?.posTag ?? .unknown,
                    gender: .unknown
                )
                
                let otherTranslations: [Translation] = $0.translations
                    .dropFirst()
                    .map {
                        Translation(
                            text: request.dto.text,
                            translation: $0.displayTarget,
                            pos: .unknown,
                            gender: .unknown
                        )
                    }
                
                
                return TranslationResultsDTO(
                    textForTranslate: request.dto.text,
                    mainTranslation: mainTranslation,
                    otherTranslations: otherTranslations
                )
            }
    }
}

