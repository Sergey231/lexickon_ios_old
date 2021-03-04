//
//  TranslationRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift

public protocol TranslationRepositoryProtocol {
    
    func translateByRapidApiGoogleTranslate(
        _ request: RapidApiGoogleTranslateRequestDTO
    ) -> Single<RapidApiGoogleTranslateResultDTO>
    
    func translateByYandexDictionary(
        _ request: YandexDictionaryApiRequestDTO
    ) -> Single<YandexDictionaryApiResultDTO>
    
    func translateByMicrosoftTranslate(
        _ request: MicrosoftTranslationRequestDTO
    ) -> Single<MicrosoftTranslatorResultsDTO>
    
    func translateByMicrosoftDictionary(
        _ request: MicrosoftTranslationRequestDTO
    ) -> Single<MicrosoftDictionaryResultsDTO>
}
