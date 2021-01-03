//
//  TranslationRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift

protocol TranslationRepositoryProtocol {
    func translate(
        _ text: String,
        tl: String,
        sl: String
    ) -> Single<TranslationResultsDTO>
}

struct TranslationResultsDTO {
    var rapidApiGoogleTranslate: RapidaApiGoogleTranslateDTO
}

struct RapidaApiGoogleTranslateDTO: Codable {
    
    var code: Int
    var data: TranslationData
    var message: String
    
    private enum CodingKays: String, CodingKey {
        case code
        case data
        case message
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try container.decode(Int.self, forKey: .code)
        data = try container.decode(TranslationData.self, forKey: .data)
        message = try container.decode(String.self, forKey: .message)
    }
    
    struct TranslationData: Codable {
        
        var translation: String
        var pronunciation: String = ""
        var pairs: [Pair] = []
        var source: Source
        var message: String = ""
        
        private enum CodingKeys: String, CodingKey {
            case translation
            case pronunciation
            case pairs
            case source
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            translation = try container.decode(String.self, forKey: .translation)
            pronunciation = try container.decode(String.self, forKey: .pronunciation)
            pairs = try container.decode([Pair].self, forKey: .pairs)
            source = try container.decode(Source.self, forKey: .source)
        }
        
        struct Pair: Codable {
            var s: String = ""
            var t: String = ""
            
            private enum CodingKeys: String, CodingKey {
                case s
                case t
            }
        }
        
        struct Source: Codable {
            
            struct Language: Codable {
                var didYouMean: Bool = false
                var iso: String = ""
                
                private enum CodingKeys: String, CodingKey {
                    case didYouMean
                    case iso
                }
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    didYouMean = try container.decode(Bool.self, forKey: .didYouMean)
                    iso = try container.decode(String.self, forKey: .iso)
                }
            }
            
            struct Text: Codable {
                var autoCorrected: Bool = false
                var value: String = ""
                var didYouMean: Bool = false
                
                private enum CodingKeys: String, CodingKey {
                    case autoCorrected
                    case value
                    case didYouMean
                }
                
                public init(from decoder: Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    autoCorrected = try container.decode(Bool.self, forKey: .autoCorrected)
                    value = try container.decode(String.self, forKey: .value)
                    didYouMean = try container.decode(Bool.self, forKey: .didYouMean)
                }
            }
            
            let language: Language
            let text: Text
            
            private enum CodingKeys: String, CodingKey {
                case language
                case text
            }
        }
    }
}
