
import Foundation
import LexickonApi

protocol ApiRepository {
    var baseURL: String { get }
}

extension ApiRepository {
    var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "BaseURL") as! String
    }
}
