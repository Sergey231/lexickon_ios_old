//
//  RapidApiGoogleTranslationDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

public struct RapidApiGoogleTranslateResultDTO: Codable {
    
    public init(
        code: Int,
        data: TranslationData,
        message: String
    ) {
        self.code = code
        self.data = data
        self.message = message
    }
    
    public let code: Int
    public let data: TranslationData
    public let message: String
    
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
    
    public struct TranslationData: Codable {
        
        public init(
            translation: String,
            pronunciation: String = "",
            pairs: [Pair] = [],
            source: Source,
            message: String = ""
        ) {
            self.translation = translation
            self.pronunciation = pronunciation
            self.pairs = pairs
            self.source = source
            self.message = message
        }
        
        public let translation: String
        public let pronunciation: String
        public let pairs: [Pair]
        public let source: Source
        public let message: String
        
        private enum CodingKeys: String, CodingKey {
            case translation
            case pronunciation
            case pairs
            case source
            case message
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            translation = try container.decode(String.self, forKey: .translation)
            pronunciation = try container.decode(String.self, forKey: .pronunciation)
            pairs = try container.decode([Pair].self, forKey: .pairs)
            source = try container.decode(Source.self, forKey: .source)
            message = try container.decode(String.self, forKey: .message)
        }
        
        public struct Pair: Codable {
            public var s: String = ""
            public var t: String = ""
            
            private enum CodingKeys: String, CodingKey {
                case s
                case t
            }
        }
        
        public struct Source: Codable {
            
            public struct Language: Codable {
                public var didYouMean: Bool = false
                public var iso: String = ""
                
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
            
            public struct Text: Codable {
                public var autoCorrected: Bool = false
                public var value: String = ""
                public var didYouMean: Bool = false
                
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
            
            public let language: Language
            public let text: Text
            
            private enum CodingKeys: String, CodingKey {
                case language
                case text
            }
        }
    }
}
