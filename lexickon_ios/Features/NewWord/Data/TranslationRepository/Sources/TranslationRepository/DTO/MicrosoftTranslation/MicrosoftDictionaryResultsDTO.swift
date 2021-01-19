//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 19.01.2021.
//

import Foundation
import LexickonApi

public struct MicrosoftDictionaryResultsDTO: Codable {
    
    public let normalizedSource: String
    public let displaySource: String
    public let translations: [Translation]
    
    enum CodingKays: String, CodingKey {
        case normalizedSource
        case displaySource
        case translations
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        normalizedSource = try container.decode(String.self, forKey: .normalizedSource)
        displaySource = try container.decode(String.self, forKey: .normalizedSource)
        translations = try container.decode([Translation].self, forKey: .translations)
    }
    
    public struct Translation: Codable {
        public let normalizedTarget: String
        public let displayTarget: String
        public let posTag: TranslationResultsDTO.Pos
        public let confidence: Double
        public let prefixWord: String
        
        enum CodingKays: String, CodingKey {
            case normalizedTarget
            case displayTarget
            case posTag
            case confidence
            case prefixWord
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKays.self)
            normalizedTarget = try container.decode(String.self, forKey: .normalizedTarget)
            displayTarget = try container.decode(String.self, forKey: .displayTarget)
            let posTagString = try container.decode(String.self, forKey: .posTag)
            posTag = TranslationResultsDTO.Pos(rawValue: posTagString.lowercased()) ?? .unknown
            confidence = try container.decode(Double.self, forKey: .confidence)
            prefixWord = try container.decode(String.self, forKey: .prefixWord)
        }
    }
}
