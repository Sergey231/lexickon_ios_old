
import Foundation
import LexickonApi
import Combine
import RxSwift
import RxCocoa
import Alamofire

final class UserRepository: UserRepositoryProtocol, ApiRepository {

    func createUser(
        with credentials: UserCreateObject
    ) -> Single<UserGetObject> {
        
        let url = baseURL + "/api/user/register"
        let parameters = [
            "email": credentials.email,
            "password": credentials.password
        ]
        
        return Single.create { single -> Disposable in
            
            AF.request(url, method: .post, parameters: parameters)
                .responseDecodable(of: UserGetObject.self) { res in
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
