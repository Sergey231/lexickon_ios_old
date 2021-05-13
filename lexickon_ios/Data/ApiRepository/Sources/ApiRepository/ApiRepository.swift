import Foundation
import LexickonApi
import Alamofire
import ConfigsRepository

public protocol ApiRepository {
    var baseURL: String { get }
    var jsonDecoder: JSONDecoder { get }
}

public class LxSessionManager {
    
    public let session: Session
    
    public init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        self.session = Session(
            configuration: configuration,
            interceptor: LxRequestInterceptor()
        )
    }
    
    public static var shared = LxSessionManager()
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
}
