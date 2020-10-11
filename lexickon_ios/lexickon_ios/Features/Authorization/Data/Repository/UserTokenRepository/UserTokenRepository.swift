
import LexickonApi
import RxCocoa
import RxSwift
import Alamofire

final class UserTokenRepository: UserTokenRepositoryProtocol, ApiRepository {
    
    func get(with credentiols: UserCreateObject) -> Single<UserTokenGetObject> {
        
        let url = baseURL + "/api/user/login"
        let parameters = [
            "email": credentiols.email,
            "password": credentiols.password
        ]
        
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
                    case .failure:
                        single(.error(HTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            
            return Disposables.create()
        }
    }
}

