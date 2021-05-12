import Foundation
import LexickonApi
import Alamofire
import ConfigsRepository

public protocol ApiRepository {
    static var lxSession: Session { get }
    var baseURL: String { get }
    var jsonDecoder: JSONDecoder { get }
}

public class LxSessionManager {
    
    public let session: Session
    
    init() {
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
    
    static var lxSession: Session {
        LxSessionManager.shared.session
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
