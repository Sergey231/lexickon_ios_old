//
//  KeyValueRepositoryProtocol.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 04.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import Foundation

protocol KeyValueRepositoryProtocol {
    func setObject(_ object: Any, forKey: LocalStorageKeys)
    func object(forKey: LocalStorageKeys) -> String?
    func objectFromConfigs(forKey: LocalStorageKeys.Configs) -> String?
}
