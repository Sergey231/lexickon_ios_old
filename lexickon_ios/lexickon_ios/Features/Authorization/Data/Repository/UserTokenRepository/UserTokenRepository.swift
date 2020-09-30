
import Foundation
import LexickonApi
import RxSwift
import RxAlamofire
import Alamofire

final class UserTokenRepository: UserTokenRepositoryProtocol, ApiRepository {
    
    func get(with loginCredentials: UserCreateObject) -> Single<UserTokenGetObject> {
        
        let urlResource = URL(string: "\(baseURL)/api/user/login")!
        let parameters = ["email": loginCredentials.email, "password": loginCredentials.password]
        
        return Single<UserTokenGetObject>.create { single -> Disposable in
            
            AF.request(urlResource, method: .post, parameters: parameters)
                .authenticate(username: loginCredentials.email, password: loginCredentials.password)
                .responseDecodable(of: UserTokenGetObject.self) { res in
                    
                    guard let response = res.response else {
                        single(.error(HTTPObject.Error.invalidResponse))
                        return
                    }
                    
                    switch response.statusCode {
                    case 200..<300:
                        guard let userToken = try? res.result.get() else {
                            single(.error(HTTPObject.Error.invalidResponse))
                            return
                        }
                        single(.success(userToken))
                    case 401:
                        single(.error(HTTPObject.Error.unauthorized))
                    default:
                        single(.error(HTTPObject.Error.unauthorized))
                    }
                }
            
            return Disposables.create()
        }
    }
}
