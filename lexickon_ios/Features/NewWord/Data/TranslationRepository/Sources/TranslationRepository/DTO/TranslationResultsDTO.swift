//
//  TraslationResultDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

public struct TranslationResultsDTO {
    
    public init(
        textForTranslate: String,
        mainTranslation: Translation,
        otherTranslations: [Translation]
    ) {
        self.textForTranslate = textForTranslate
        self.mainTranslation = mainTranslation
        self.otherTranslations = otherTranslations
    }
    
    public let textForTranslate: String
    public let mainTranslation: Translation
    public let otherTranslations: [Translation]
    
    public enum Pos: String, Codable {
        case noun
        case verb
        case adjective
        case adverb
        case conjunction
        case pronoun
        case numerals
        case unknown
    }
    
    public enum Gender: String, Codable {
        case man
        case woman
        case neuter
        case unknown
    }
    
    public struct Translation {
        public init(
            text: String,
            translation: String,
            pos: Pos,
            gender: Gender
        ) {
            self.text = text
            self.translation = translation
            self.pos = pos
            self.gender = gender
        }
        public let text: String
        public let translation: String
        public let pos: Pos
        public let gender: Gender
    }
}
