//
//  LocalStorageKeys.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

enum LocalStorageKeys {
    case targetLanguage
    case sourceLanguage
    case configs(Configs)
    
    var key: String {
        switch self {
        case .targetLanguage: return "targetLanguage"
        case .sourceLanguage: return "sourceLanguage"
        case .configs(let configs): return configs.key
        }
    }
    
    enum Configs {
        case rapidApiKey
        case rapidApiHost
        
        var key: String {
            switch self {
            case .rapidApiKey: return "rapidApiKey"
            case .rapidApiHost: return "rapidApiHost"
            }
        }
    }
}
