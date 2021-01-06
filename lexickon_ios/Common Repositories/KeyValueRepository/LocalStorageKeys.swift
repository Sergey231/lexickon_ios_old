//
//  LocalStorageKeys.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

enum LocalStorageKeys: String {
    
    case targetLanguage
    case sourceLanguage
    
    enum Configs: String {
        case rapidApiGoogleTranslateKey
        case rapidApiGoogleTranslateHost
    }
}
