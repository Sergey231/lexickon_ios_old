//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 13.01.2021.
//

import Foundation
import SwiftKeychainWrapper

public typealias KeychainRepositoryKeys = KeychainWrapper.Key

public extension KeychainWrapper.Key {
    static let authToken: KeychainWrapper.Key = "authToken"
    static let authTokenId: KeychainWrapper.Key = "authTokenId"
}
