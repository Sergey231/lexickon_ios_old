import Foundation
import LexickonApi
import Alamofire
import KeychainRepository
import ConfigsRepository

public protocol ApiRepository {
    var baseURL: String { get }
    var jsonDecoder: JSONDecoder { get }
    var headersWithAuthToken: HTTPHeaders? { get }
}

public extension ApiRepository {
    var baseURL: String {
        ConfigsRepository().object(forKey: .BaseURL)!
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        return decoder
    }
    
    var headersWithAuthToken: HTTPHeaders? {
        
        let authToken = KeychainRepository().object(forKey: .authToken)
        
        guard let strongAuthToken = authToken else {
            return nil
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(strongAuthToken)"
        ]
        
        return headers
    }
}
