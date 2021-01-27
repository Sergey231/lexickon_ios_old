//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 17.01.2021.
//

import Foundation
import LexickonApi

public struct MicrosoftTranslationRequestDTO {
    public let baseUrl: String
    public let dto: TranslationRequestDTO
    public let subscriptionKey: String
    public let subscriptionRegion: String
    public init(
        baseUrl: String,
        dto: TranslationRequestDTO,
        subscriptionKey: String,
        subscriptionRegion: String
    ) {
        self.baseUrl = baseUrl
        self.dto = dto
        self.subscriptionKey = subscriptionKey
        self.subscriptionRegion = subscriptionRegion
    }
}
