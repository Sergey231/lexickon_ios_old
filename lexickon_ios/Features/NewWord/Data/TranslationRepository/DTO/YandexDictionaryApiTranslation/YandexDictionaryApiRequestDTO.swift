//
//  YandexDictionaryApiRequestDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation
import LexickonApi

struct YandexDictionaryApiRequestDTO {
    let key: String
    let lang: (sourceLanguage: LanguageObject, targetLanguage: LanguageObject)
    let text: String
}
