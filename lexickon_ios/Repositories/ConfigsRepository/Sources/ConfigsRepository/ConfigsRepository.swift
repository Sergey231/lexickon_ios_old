//
//  KeyValueRepository.swift
//  Investment
//
//  Created by Sergey Borovikov on 13.01.2021.
//

import Foundation

public final class ConfigsRepository: ConfigsRepositoryProtocol {
    
    public init() {}
    
    public func object(forKey: ConfigsRepositoryKeys) -> String? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: forKey.rawValue) else {
            return nil
        }
        return value as? String
    }
}
