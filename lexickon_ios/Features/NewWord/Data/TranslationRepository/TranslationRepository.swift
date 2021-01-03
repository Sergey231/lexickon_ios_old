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

    func translate(
        _ text: String,
        tl: String = "ru",
        sl: String = "en"
    ) -> Single<TranslationResultsDTO> {
        
        let url = "https://google-translate20.p.rapidapi.com/translate?text=\(text)&tl=\(tl)&sl=\(sl)"
        
        let headers: HTTPHeaders = [
            "x-rapidapi-key": "bd0047b6c1msh466cb1752c5bae5p17fe30jsne60b241dad74",
            "x-rapidapi-host" : "google-translate20.p.rapidapi.com"
        ]
        
        return Single.create { single -> Disposable in
            AF.request(url, headers: headers) { req in
                print(req)
            }
            .responseDecodable(
                of: RapidaApiGoogleTranslateDTO.self,
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
