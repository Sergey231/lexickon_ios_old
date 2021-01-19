//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 17.01.2021.
//

import Foundation
import LexickonApi

public struct MicrosoftTranslatorResultsDTO: Codable {
    public let translations: [Translation]
    private enum CodingKays: String, CodingKey {
        case translations
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        translations = try container.decode([Translation].self, forKey: .translations)
    }
    
    public struct Translation: Codable {
        public let text: String
        public let to: String
    }
}
