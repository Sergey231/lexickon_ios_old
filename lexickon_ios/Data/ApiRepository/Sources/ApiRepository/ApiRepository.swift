import Foundation
import LexickonApi
import Alamofire
import ConfigsRepository

public protocol ApiRepository {
    static var lxSession: Session { get }
    var baseURL: String { get }
    var jsonDecoder: JSONDecoder { get }
}

public extension ApiRepository {
    
    static var lxSession: Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.waitsForConnectivity = true
        
        return Session(
            configuration: configuration,
            interceptor: LxRequestInterceptor()
        )
    }
    
    var baseURL: String {
        ConfigsRepository().object(forKey: .BaseURL)!
    }
    
    var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601)
        return decoder
    }
}
