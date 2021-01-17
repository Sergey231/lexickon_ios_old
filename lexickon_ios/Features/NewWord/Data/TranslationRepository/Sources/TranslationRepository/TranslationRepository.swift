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
import ApiRepository

public final class TranslationRepository: TranslationRepositoryProtocol, ApiRepository {
    
    public init() {}
    
    public func translateByRapidApiGoogleTranslate(
        _ request: RapidApiGoogleTranslateRequestDTO
    ) -> Single<RapidApiGoogleTranslateResultDTO> {
        
        let url = "https://\(request.rapidApiHost)"
            + "/translate?text=\(request.dto.text)"
            + "&tl=\(request.dto.targetLanguage)"
            + "&sl=\(request.dto.sourceLanguage)"
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": request.rapidApiKey,
            "x-rapidapi-host" : request.rapidApiHost
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
    
    public func translateByYandexDictionary(
        _ request: YandexDictionaryApiRequestDTO
    ) -> Single<YandexDictionaryApiResultDTO> {
        
        guard
            !request.dto.text.isEmpty,
            !request.key.isEmpty
        else {
            return Single.error(LxHTTPObject.Error.invalidRepositoryRequest)
        }
        
        let url = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?"
            + "key=\(request.key)"
            + "&lang=\(request.dto.sourceLanguage)-\(request.dto.targetLanguage)"
            + "&text=\(request.dto.text)"
        
        return Single.create { single -> Disposable in
            AF.request(url) { req in
                print(req)
            }
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
    
    public func translateByMicrosoftTranslate(
        _ request: MicrosoftTranslatorRequestDTO
    ) -> Single<MicrosoftTranslatorResultsDTO> {
        
        guard
            !request.dto.text.isEmpty,
            !request.subscriptionKey.isEmpty
        else {
            return Single.error(LxHTTPObject.Error.invalidRepositoryRequest)
        }
        
        let url = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0"
            + "&to=\(request.dto.targetLanguage)"
            + "&from=\(request.dto.sourceLanguage)"
        
        let parametrs = [["Text": "hi"]]
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Region": "northeurope",
            "Ocp-Apim-Subscription-Key": "ff3b39475f4a41b8ae887b03deb093dd",
            "Content-Type" : "application/json"
        ]
        
        return Single.create { single -> Disposable in
            AF.request(url, method: .post, parameters: parametrs, headers: headers)
                .response { res in
                    let json = String(data: res.data!, encoding: String.Encoding.utf8)
                    print(json)
                }
//                .responseDecodable(
//                    of: [MicrosoftTranslatorResultsDTO].self,
//                    decoder: self.jsonDecoder
//                ) { res in
//                    switch res.result {
//                    case .success(let model):
//                        if model.isEmpty {
//                            single(.failure(LxHTTPObject.Error.invalidResponse))
//                        } else {
//                            single(.success(model.first!))
//                        }
//                    case .failure(let failure):
//                        print(failure)
//                        single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
//                    }
//                }
            return Disposables.create()
        }
    }
}
