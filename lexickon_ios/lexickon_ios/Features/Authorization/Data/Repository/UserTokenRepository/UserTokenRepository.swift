
import LexickonApi
import RxCocoa
import RxSwift
import Alamofire

final class UserTokenRepository: UserTokenRepositoryProtocol {
    
    func get(with credentiols: UserCreateObject) -> Single<UserTokenGetObject> {
        
        let url = "http://localhost:8080/api/user/login"
        let parameters = ["email": credentiols.email, "password": credentiols.password]
        
        return Single.create { single -> Disposable in
            
            AF.request(url, method: .post, parameters: parameters)
                .authenticate(
                    username: credentiols.email,
                    password: credentiols.password
                )
                .responseDecodable(of: UserTokenGetObject.self) { res in
                    
                    switch res.result {
                    case .success(let model):
                        single(.success(model))
                    case .failure(_):
                        single(.error(HTTPObject.Error.handleError(res.response?.statusCode)))
                    }
                }
            
            return Disposables.create()
        }
    }
}

