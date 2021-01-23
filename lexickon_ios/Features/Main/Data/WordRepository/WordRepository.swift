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

public final class WordRepository: WordRepositoryProtocol, ApiRepository {
    
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
    
    public func add(_ word: LxWordCreate) -> Single<_LxWordGet> {
        
        guard let headers = headersWithAuthToken else {
            return .error(LxHTTPObject.Error.unauthorized)
        }
        
        let url = baseURL + "/api/words/"
        
        let parametrs: Parameters = [
            "studyWord" : word.studyWord,
            "translates" : word.translates,
            "image" : word.image
        ]
        
        return Single.create { single -> Disposable in
            
            AF.request(url, method: .post, parameters: parametrs, headers: headers)
                .responseDecodable(
                    of: _LxWordGet.self,
                    decoder: self.jsonDecoder
                ) { res in

                    switch res.result {
                    case .success(let model):
                        print(model)
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


public struct _LxWordGet: Codable {
    
    public init(
        id: UUID,
        studyWord: String,
        translates: [String],
        nextLessonDate: Date,
        image: String
    ) {
        self.id = id
        self.studyWord = studyWord
        self.translates = translates
        self.nextLessonDate = nextLessonDate
        self.image = image
    }
    
    public let id: UUID
    public let studyWord: String
    public let translates: [String]
    public let nextLessonDate: Date
    public let image: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case studyWord
        case translates
        case nextLessonDate
        case image
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        studyWord = try container.decode(String.self, forKey: .studyWord)
        translates = try container.decode([String].self, forKey: .translates)
        image = try container.decode(String.self, forKey: .image)
        
        let nextLessonDateString = try container.decode(String.self, forKey: .nextLessonDate)
        let dateFormatter = DateFormatter.iso8601
        if let date = dateFormatter.date(from: nextLessonDateString) {
            nextLessonDate = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .nextLessonDate,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }
    }
}
