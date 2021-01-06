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

    func translate(_ input: RapidApiGoogleTranslateInputDTO) -> Single<TranslationResultsDTO> {
        
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
                    let translation = TranslationResultsDTO(rapidApiGoogleTranslate: model)
                    single(.success(translation))
                case .failure(let failure):
                    print(failure)
                    single(.error(LxHTTPObject.Error(with: res.response?.statusCode)))
                }
            }
            return Disposables.create()
        }
    }
}
