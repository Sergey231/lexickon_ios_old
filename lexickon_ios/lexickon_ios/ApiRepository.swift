
import Foundation

protocol ApiRepository {
    var baseURL: String { get }
}

extension ApiRepository {
    var baseURL: String {
        let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL")!
        return baseURL as! String
    }
}
