//
//  KeyValueRepository.swift
//  Investment
//
//  Created by Sergey Borovikov on 13.01.2021.
//

import Foundation

public final class KeyValueRepository: KeyValueRepositoryProtocol {
    
    private let userDefaults = UserDefaults.standard
    
    public init() {}
    
    public func setObject(_ object: Any, forKey: KeyValueRepositoryKeys) {
        userDefaults.setValue(object, forKey: forKey.rawValue)
        userDefaults.synchronize()
    }
    
    public func object(forKey: KeyValueRepositoryKeys) -> String? {
        return userDefaults.object(forKey: forKey.rawValue) as? String
    }
}
