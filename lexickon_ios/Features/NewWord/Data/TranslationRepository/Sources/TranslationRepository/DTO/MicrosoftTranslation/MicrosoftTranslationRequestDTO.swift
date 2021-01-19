//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 17.01.2021.
//

import Foundation
import LexickonApi

public struct MicrosoftTranslationRequestDTO {
    public let dto: TranslationRequestDTO
    public let subscriptionKey: String
    public let subscriptionRegion: String
    public init(
        dto: TranslationRequestDTO,
        subscriptionKey: String,
        subscriptionRegion: String
    ) {
        self.dto = dto
        self.subscriptionKey = subscriptionKey
        self.subscriptionRegion = subscriptionRegion
    }
}
