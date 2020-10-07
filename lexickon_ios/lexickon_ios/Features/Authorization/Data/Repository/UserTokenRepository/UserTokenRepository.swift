
import LexickonApi
import RxCocoa
import RxSwift
import Alamofire

final class UserTokenRepository: UserTokenRepositoryProtocol {
    
    func get(with credentiols: UserCreateObject) -> Single<UserTokenGetObject> {
        
        let url = "http://lonalhost:8080/api/users/login"
        let parameters = ["login": credentiols.email, "password": credentiols.password]
        
        return Single.create { single -> Disposable in
            
            AF.request(url, method: .post, parameters: parameters)
                .authenticate(
                    username: credentiols.email,
                    password: credentiols.password
                )
                .responseDecodable(of: UserTokenGetObject.self) { res in
                    print(res)
                }
            
            return Disposables.create()
        }
    }
}

