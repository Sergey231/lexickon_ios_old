//
//  RapidAPIGoogleTranslateInputDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

public struct RapidApiGoogleTranslateRequestDTO {
    public let dto: TranslationRequestDTO
    public let rapidApiKey: String
    public let rapidApiHost: String
    public init(
        dto: TranslationRequestDTO,
        rapidApiKey: String,
        rapidApiHost: String
    ) {
        self.dto = dto
        self.rapidApiKey = rapidApiKey
        self.rapidApiHost = rapidApiHost
    }
}
