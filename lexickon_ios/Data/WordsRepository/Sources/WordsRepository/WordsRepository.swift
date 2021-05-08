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
import Foundation
import ApiRepository

public final class WordsRepository: WordsRepositoryProtocol, ApiRepository {
    
    public init() {}
    
    public func words(per: Int, page: Int) -> Single<LxPage<LxWordList>> {
        
        guard let headers = headersWithAuthToken else {
            return .error(LxHTTPObject.Error.unauthorized)
        }
        
        let url = baseURL + "/api/words?per=\(per)&page=\(page)"
        
        return Single.create { single -> Disposable in
            
            AF.request(url, headers: headers)
                .responseDecodable(
                    of: LxPage<LxWordList>.self,
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
    
    public func word(by id: String) -> Single<LxWordGet> {
        
        guard let headers = headersWithAuthToken else {
            return .error(LxHTTPObject.Error.unauthorized)
        }
        
        let url = baseURL + "/api/words/\(id)"
        
        return Single.create { single -> Disposable in
            
            AF.request(url, headers: headers)
                .responseDecodable(
                    of: LxWordGet.self,
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
    
    public func add(_ words: [LxWordCreate]) -> Single<[LxWordGet]> {
        
        guard let headers = headersWithAuthToken else {
            return .error(LxHTTPObject.Error.unauthorized)
        }
        
        guard let url = URL(string: baseURL + "/api/addWords") else {
            return .error(LxHTTPObject.Error.invalidRepositoryRequest)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let wordsParametrs = words.map {
            [
                "studyWord" : $0.studyWord,
                "translates" : $0.translates,
                "image" : $0.image
            ]
        }
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: wordsParametrs)
        request.headers = headers
        
        return Single.create { single -> Disposable in
            
            AF.request(request)
                .responseDecodable(
                    of: [LxWordGet].self,
                    decoder: self.jsonDecoder
                ) { res in

                    switch res.result {
                    case .success(let model):
                        single(.success(model))
                    case .failure(let failure):
                        single(.failure(LxHTTPObject.Error(with: failure.responseCode)))
                    }
                }
            return Disposables.create()
        }
    }
}
