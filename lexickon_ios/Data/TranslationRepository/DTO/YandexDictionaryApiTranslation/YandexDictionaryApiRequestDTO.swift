//
//  YandexDictionaryApiRequestDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation
import LexickonApi

public struct YandexDictionaryApiRequestDTO {
    public let dto: TranslationRequestDTO
    public let key: String
    public init(
        dto: TranslationRequestDTO,
        key: String
    ) {
        self.dto = dto
        self.key = key
    }
}
