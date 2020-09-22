
import Foundation
import LexickonApi
import Combine

final class UserTokenRepository: UserTokenRepositoryProtocol, ApiRepository {
    
    func get(with tokin: UserCreateObject) -> AnyPublisher<UserTokenGetObject, HTTPObject.Error> {
        
        let urlResource = URL(string: "\(baseURL)/api/user/login")!
        var request = URLRequest(url: urlResource)
        request.httpMethod = HTTPObject.Method.get.rawValue.uppercased()
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            sleep(3)
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, reqponse in
                guard let httpResponse = reqponse as? HTTPURLResponse else {
                    throw HTTPObject.Error.invalidResponse
                }
                guard httpResponse.statusCode == 200 else {
                    throw HTTPObject.Error.statusCode(httpResponse.statusCode)
                }
                return data
            }
            .decode(type: UserTokenGetObject.self, decoder: decoder)
            .mapError { error -> HTTPObject.Error in
                if let httpError = error as? HTTPObject.Error {
                    return httpError
                }
                return HTTPObject.Error.unknown(error)
            }
            .eraseToAnyPublisher()
    }
}
