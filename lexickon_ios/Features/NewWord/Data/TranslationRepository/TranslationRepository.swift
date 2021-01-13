//
//  TranslationRepository.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import Foundation
import Alamofire
import LexickonApi

final class TranslationRepository: TranslationRepositoryProtocol, ApiRepository {
    
    func translateByRapidApiGoogleTranslate(
        _ input: RapidApiGoogleTranslateRequestDTO
    ) -> Single<RapidApiGoogleTranslateResultDTO> {
        
        let url = "https://"
        + input.rapidApiHost
        + "/translate?text="
        + input.text
        + "&tl="
        + input.targetLanguage
        + "&sl="
        + input.sourceLanguage
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": input.rapidApiKey,
            "x-rapidapi-host" : input.rapidApiHost
        ]
        
        return Single.create { single -> Disposable in
            AF.request(url, headers: headers) { req in
                print(req)
            }
            .responseDecodable(
                of: RapidApiGoogleTranslateResultDTO.self,
                decoder: self.jsonDecoder
            ) { res in
                switch res.result {
                case .success(let model):
                    single(.success(model))
                case .failure(let failure):
                    print(failure)
                    single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
                }
            }
            return Disposables.create()
        }
    }
    
    func translateByYandexDictionary(
        _ input: YandexDictionaryApiRequestDTO
    ) -> Single<YandexDictionaryApiResultDTO> {
        
        guard
            !input.text.isEmpty,
            !input.key.isEmpty
        else {
            return Single.error(LxHTTPObject.Error.invalidRepositoryRequest)
        }
        
        let url = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?"
            + "key=\(input.key)"
            + "&lang=\(input.lang.sourceLanguage)-\(input.lang.targetLanguage)"
            + "&text=\(input.text)"
        return Single.create { single -> Disposable in
            AF.request(url) { req in
                print(req)
            }
//            .response { res in
//
//                print(String(decoding: res.data!, as: UTF8.self))
//            }
            .responseDecodable(
                of: YandexDictionaryApiResultDTO.self,
                decoder: self.jsonDecoder
            ) { res in
                switch res.result {
                case .success(let model):
                    single(.success(model))
                case .failure(let failure):
                    print(failure)
                    single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
                }
            }
            return Disposables.create()
        }
    }
}
