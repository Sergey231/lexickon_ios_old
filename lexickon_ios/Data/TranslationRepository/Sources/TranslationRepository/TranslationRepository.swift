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
            AF.request(url, headers: headers)
                .responseDecodable(
                    of: RapidApiGoogleTranslateResultDTO.self,
                    decoder: self.jsonDecoder
                ) { res in
                    switch res.result {
                    case .success(let model):
                        single(.success(model))
                    case .failure:
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
            AF.request(url)
                .responseDecodable(
                    of: YandexDictionaryApiResultDTO.self,
                    decoder: self.jsonDecoder
                ) { res in
                    switch res.result {
                    case .success(let model):
                        single(.success(model))
                    case .failure:
                        single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            return Disposables.create()
        }
    }
    
    public func translateByMicrosoftTranslate(
        _ request: MicrosoftTranslationRequestDTO
    ) -> Single<MicrosoftTranslatorResultsDTO> {
        
        guard
            !request.dto.text.isEmpty,
            !request.subscriptionKey.isEmpty,
            !request.subscriptionRegion.isEmpty
        else {
            return Single.error(LxHTTPObject.Error.invalidRepositoryRequest)
        }
        
        let url = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0"
            + "&to=\(request.dto.targetLanguage)"
            + "&from=\(request.dto.sourceLanguage)"
        
        let parameters : [Parameters] = [["Text": request.dto.text]]
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Region": request.subscriptionRegion,
            "Ocp-Apim-Subscription-Key": request.subscriptionKey,
            "Content-Type" : "application/json"
        ]
        
        return Single.create { single -> Disposable in
            AF.request(
                url,
                method: .post,
                encoding: JSONArrayEncoding(array: parameters),
                headers: headers
            )
                .responseDecodable(
                    of: [MicrosoftTranslatorResultsDTO].self,
                    decoder: self.jsonDecoder
                ) { res in
                    switch res.result {
                    case .success(let model):
                        if model.isEmpty {
                            single(.failure(LxHTTPObject.Error.invalidResponse))
                        } else {
                            single(.success(model.first!))
                        }
                    case .failure:
                        single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            return Disposables.create()
        }
    }
    
    public func translateByMicrosoftDictionary(
        _ request: MicrosoftTranslationRequestDTO
    ) -> Single<MicrosoftDictionaryResultsDTO> {
        
        guard
            !request.baseUrl.isEmpty,
            !request.dto.text.isEmpty,
            !request.subscriptionKey.isEmpty,
            !request.subscriptionRegion.isEmpty
        else {
            return Single.error(LxHTTPObject.Error.invalidRepositoryRequest)
        }
        
        let url = request.baseUrl
            + "/Dictionary/Lookup?api-version=3.0"
            + "&to=\(request.dto.targetLanguage)"
            + "&from=\(request.dto.sourceLanguage)"
        
        let parameters : [Parameters] = [["Text": request.dto.text]]
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Region": request.subscriptionRegion,
            "Ocp-Apim-Subscription-Key": request.subscriptionKey,
            "Content-Type": "application/json"
        ]
        
        return Single.create { single -> Disposable in
            AF.request(
                url,
                method: .post,
                encoding: JSONArrayEncoding(array: parameters),
                headers: headers
            )
                .responseDecodable(
                    of: [MicrosoftDictionaryResultsDTO].self,
                    decoder: self.jsonDecoder
                ) { res in                    switch res.result {
                    case .success(let model):
                        if model.isEmpty {
                            single(.failure(LxHTTPObject.Error.invalidResponse))
                        } else {
                            single(.success(model.first!))
                        }
                    case .failure:
                        single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            return Disposables.create()
        }
    }
}


struct JSONArrayEncoding: ParameterEncoding {
    
    private let array: [Parameters]

    init(array: [Parameters]) {
        self.array = array
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        let data = try JSONSerialization.data(withJSONObject: array, options: [])

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        urlRequest.httpBody = data

        return urlRequest
    }
}
