//
//  WordRepository.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 05.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import LexickonApi
import RxSwift
import Alamofire
import SwiftKeychainWrapper

final class WordRepository: WordRepositoryProtocol, ApiRepository {
    
    func words(per: Int, page: Int) -> Single<PageObject<WordListObject>> {
        
        let authToken: String? = KeychainWrapper.standard[.authToken]
        
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(String(describing: authToken))",
            "Accept": "application/json"
        ]
        
        let url = baseURL + "/api/words?per=\(per)&page=\(page)"
        
        return Single.create { single -> Disposable in
            
            AF.request(url, headers: headers)
                .responseDecodable(of: PageObject<WordListObject>.self) { res in
                    switch res.result {
                    case .success(let model):
                        single(.success(model))
                    case .failure:
                        single(.error(HTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            
            return Disposables.create()
        }
    }
}
