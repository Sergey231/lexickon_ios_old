//
//  KeyValueRepositoryProtocol.swift
//  Investment
//
//  Created by Sergey Borovikov on 13.01.2021.
//

import Foundation

public protocol KeyValueRepositoryProtocol {
    func setObject(_ object: Any, forKey: KeyValueRepositoryKeys)
    func object(forKey: KeyValueRepositoryKeys) -> String?
}
