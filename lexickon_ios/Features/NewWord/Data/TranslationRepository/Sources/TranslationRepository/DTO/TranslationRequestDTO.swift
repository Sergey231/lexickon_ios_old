//
//  TranslationRequestDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation
import LexickonApi

public struct TranslationRequestDTO {
    public init(
        text: String,
        targetLanguage: LanguageObject,
        sourceLanguage: LanguageObject
    ) {
        self.text = text
        self.targetLanguage = targetLanguage
        self.sourceLanguage = sourceLanguage
    }
    public let text: String
    public let targetLanguage: LanguageObject
    public let sourceLanguage: LanguageObject
}
