
import Foundation
import Alamofire
import LexickonApi
import SwiftKeychainWrapper

protocol ApiRepository {
    var baseURL: String { get }
    var jsonDecoder: JSONDecoder { get }
    var headersWithAuthToken: HTTPHeaders? { get }
}

extension ApiRepository {
    var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        return decoder
    }
    
    var headersWithAuthToken: HTTPHeaders? {
        
        let authToken: String? = KeychainWrapper.standard[.authToken]
        
        guard let strongAuthToken = authToken else {
            return nil
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(strongAuthToken)"
        ]
        
        return headers
    }
}
