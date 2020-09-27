
import Foundation
import LexickonApi
import RxSwift
import RxAlamofire

final class UserTokenRepository: UserTokenRepositoryProtocol, ApiRepository {
    
    func get(with loginCredentials: UserCreateObject) -> Single<UserTokenGetObject> {
        
        let urlResource = URL(string: "\(baseURL)/api/user/login")!
        
        let parametrs = ["email": loginCredentials.email, "password": loginCredentials.hashedPassword]
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do { sleep(1) }
        
        _ = RxAlamofire.requestJSON(
            .post,
            urlResource,
            parameters: parametrs
        )
        .asSingle()
        .subscribe(
            onSuccess: { response in
                print(response)
            }, onError: { error in
                print(error.localizedDescription)
            }
        )
        
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { data, reqponse in
//                guard let httpResponse = reqponse as? HTTPURLResponse else {
//                    throw HTTPObject.Error.invalidResponse
//                }
//                guard httpResponse.statusCode == 200 else {
//                    throw HTTPObject.Error.statusCode(httpResponse.statusCode)
//                }
//                return data
//            }
//            .decode(type: UserTokenGetObject.self, decoder: decoder)
//            .mapError { error -> HTTPObject.Error in
//                if let httpError = error as? HTTPObject.Error {
//                    return httpError
//                }
//                return HTTPObject.Error.unknown(error)
//            }
//            .eraseToAnyPublisher()
//            .asObservable()
//            .asSingle()
        
        return .just(UserTokenGetObject(value: "", userId: ""))
    }
}
