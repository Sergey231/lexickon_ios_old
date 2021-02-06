//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 13.01.2021.
//

import Foundation

public protocol KeychainRepositoryProtocol {
    func setObject(_ object: String, forKey: KeychainRepositoryKeys)
    func object(forKey: KeychainRepositoryKeys) -> String?
    func removeObject(forKey key: KeychainRepositoryKeys)
}
