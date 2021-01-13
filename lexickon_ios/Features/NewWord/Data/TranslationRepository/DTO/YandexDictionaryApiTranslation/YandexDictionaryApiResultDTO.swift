//
//  YandexDictionaryApiResultDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

struct YandexDictionaryApiResultDTO: Codable {
    
    let def: [Def]
    
enum CodingKays: String, CodingKey {
        case def
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        def = try container.decode([Def].self, forKey: .def)
    }
    
    struct Def: Codable {
        let text: String
        let pos: TranslationResultsDTO.Pos
        let ts: String
        let tr: [Translation]
        let mean: [Mean]
        let ex: [Expration]
        
        private enum CodingKeys: String, CodingKey {
            case text
            case pos
            case ts
            case tr
            case mean
            case ex
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            text = try container.decode(String.self, forKey: .text)
            pos = try container.decode(TranslationResultsDTO.Pos.self, forKey: .pos)
            ts = try container.decode(String.self, forKey: .ts)
            tr = try container.decode([Translation].self, forKey: .tr)
            mean = try container.decode([Mean].self, forKey: .mean)
            ex = try container.decode([Expration].self, forKey: .ex)
        }
    }
    
    struct Translation: Codable {
        let text: String
        let pos: TranslationResultsDTO.Pos
        let gen: TranslationResultsDTO.Gender
        let syn: [Synonym]
    }
    
    struct Synonym: Codable {
        let text: String
        let pos: TranslationResultsDTO.Pos
        let gen: TranslationResultsDTO.Gender
    }
    
    struct Mean: Codable {
        let text: String
    }
    
    struct Expration: Codable {
        let text: String
        let tr: [Translation]
    }
}
