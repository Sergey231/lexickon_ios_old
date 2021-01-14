
import Foundation
import SwiftKeychainWrapper

public final class KeychainRepository: KeychainRepositoryProtocol {
    
    public init() {}
    
    private let keychain = KeychainWrapper.standard
    
    public func setObject(_ object: String, forKey key: KeychainRepositoryKeys) {
        keychain[key] = object
    }
    
    public func object(forKey key: KeychainRepositoryKeys) -> String? {
        keychain[key]
    }
    
    public func removeObject(forKey key: KeychainRepositoryKeys) {
        keychain.removeObject(forKey: key.rawValue)
    }
}
