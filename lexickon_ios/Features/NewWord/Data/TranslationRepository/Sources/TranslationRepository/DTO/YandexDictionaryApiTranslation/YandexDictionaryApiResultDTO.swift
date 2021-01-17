//
//  YandexDictionaryApiResultDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

public struct YandexDictionaryApiResultDTO: Codable {
    
    public let def: [Def]
    
    enum CodingKays: String, CodingKey {
        case def
    }
    
    public typealias Pos = TranslationResultsDTO.Pos
    public typealias Gender = TranslationResultsDTO.Gender
    
    public init(def: [Def]) {
        self.def = def
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        def = try container.decode([Def].self, forKey: .def)
    }
    
    public struct Def: Codable {
        public let text: String
        public let pos: Pos
        public let ts: String
        public let tr: [Translation]
        public let mean: [Mean]
        public let ex: [Expration]
        
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
            
            text = (try? container.decode(String.self, forKey: .text)) ?? ""
            pos = (try? container.decode(Pos.self, forKey: .pos)) ?? .unknown
            ts = (try? container.decode(String.self, forKey: .ts)) ?? ""
            tr = (try? container.decode([Translation].self, forKey: .tr)) ?? []
            mean = (try? container.decode([Mean].self, forKey: .mean)) ?? []
            ex = (try? container.decode([Expration].self, forKey: .ex)) ?? []
        }
    }
    
    public struct Translation: Codable {
        public let text: String
        public let pos: Pos
        public let gen: TranslationResultsDTO.Gender
        public let syn: [Synonym]
        
        private enum CodingKeys: String, CodingKey {
            case text
            case pos
            case gen
            case syn
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decode(String.self, forKey: .text)
            pos = (try? container.decode(Pos.self, forKey: .pos)) ?? .unknown
            gen = (try? container.decode(Gender.self, forKey: .pos)) ?? .unknown
            syn = (try? container.decode([Synonym].self, forKey: .syn)) ?? []
        }
    }
    
    public struct Synonym: Codable {
        public let text: String
        public let pos: Pos
        public let gen: Gender
        
        private enum CodingKeys: String, CodingKey {
            case text
            case pos
            case gen
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decode(String.self, forKey: .text)
            pos = (try? container.decode(Pos.self, forKey: .pos)) ?? .unknown
            gen = (try? container.decode(Gender.self, forKey: .pos)) ?? .unknown
        }
    }
    
    public struct Mean: Codable {
        public let text: String
    }
    
    public struct Expration: Codable {
        public let text: String
        public let tr: [Translation]
        
        private enum CodingKeys: String, CodingKey {
            case text
            case tr
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            text = try container.decode(String.self, forKey: .text)
            tr = (try? container.decode([Translation].self, forKey: .tr)) ?? []
        }
    }
}
