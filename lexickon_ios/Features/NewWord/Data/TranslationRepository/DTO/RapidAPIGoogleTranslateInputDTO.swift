//
//  RapidAPIGoogleTranslateInputDTO.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

struct RapidApiGoogleTranslateInputDTO {
    let text: String
    let rapidApiKey: String
    let rapidApiHost: String
    let targetLanguage: String
    let sourceLanguage: String
}
