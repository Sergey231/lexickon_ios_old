
import Foundation
import LexickonApi
import Combine

final class UserRepository: UserRepositoryProtocol, ApiRepository {
    
    func createUser(
        with credentions: UserCreateObject
    ) -> AnyPublisher<UserGetObject, HTTPObject.Error> {
        let urlResource = URL(string: "\(baseURL)/api/user")!
        var request = URLRequest(url: urlResource)
        request.httpMethod = HTTPObject.Method.post.rawValue
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap ({ data, request in
                guard let httpResponse = request as? HTTPURLResponse else {
                    throw HTTPObject.Error.invalidResponse
                }
                guard httpResponse.statusCode == 200 else {
                    throw HTTPObject.Error.statusCode(httpResponse.statusCode)
                }
                return data
            })
            .decode(type: UserGetObject.self, decoder: decoder)
            .mapError ({ error -> HTTPObject.Error in
                if let httpError = error as? HTTPObject.Error {
                    return httpError
                }
                return HTTPObject.Error.unknown(error)
            })
            .eraseToAnyPublisher()
    }
}
