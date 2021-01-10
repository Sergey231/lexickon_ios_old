//
//  TraslationResultDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 09.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

struct TranslationResultsDTO {
    
    let textForTranslate: String
    let translations: [TranslationItem]
    
    enum Pos: String, Codable {
        case noun
        case verb
        case adjective
        case adverb
        case conjunction
        case pronoun
        case numerals
        case unknown
    }
    
    enum Gender: String, Codable {
        case man
        case woman
        case neuter
        case unknown
    }
    
    struct TranslationItem {
        let translation: String
        let pos: Pos
        let gender: Gender
    }
}
