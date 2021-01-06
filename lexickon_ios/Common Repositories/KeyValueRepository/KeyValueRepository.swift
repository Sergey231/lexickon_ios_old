//
//  KeyValueRepository.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

final class KeyValueRepository: KeyValueRepositoryProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    func setObject(_ object: Any, forKey: LocalStorageKeys) {
        userDefaults.setValue(object, forKey: forKey.rawValue)
        userDefaults.synchronize()
    }
    
    func object(forKey: LocalStorageKeys) -> String? {
        return userDefaults.object(forKey: forKey.rawValue) as? String
    }
    
    func objectFromConfigs(forKey: LocalStorageKeys.Configs) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: forKey.rawValue) else {
            return nil
        }
        return value as? String
    }
}
