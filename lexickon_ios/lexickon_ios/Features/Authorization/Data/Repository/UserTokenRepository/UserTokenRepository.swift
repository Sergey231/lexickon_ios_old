
import LexickonApi
import RxCocoa
import RxSwift
import Alamofire
import SwiftKeychainWrapper

final class UserTokenRepository: UserTokenRepositoryProtocol, ApiRepository {
    
    private let keychain = KeychainWrapper.standard
    
    func get(with credentiols: UserCreateObject) -> Single<UserTokenGetObject> {
        
        let keychain = self.keychain
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
                        keychain[.authTokenId] = model.id
                        keychain[.authToken] = model.value
                        single(.success(model))
                    case .failure:
                        single(.error(HTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    var cach: Single<UserTokenGetObject> {
        let keychain = self.keychain
        return Single.create { single -> Disposable in
            
            let authTokenId: String? = keychain[.authTokenId]
            let authToken: String? = keychain[.authToken]
            
            guard
                let strongAuthTokenId = authTokenId,
                let strongAuthToken = authToken
            else {
                single(.error(HTTPObject.Error.unknown))
                return Disposables.create()
            }
            
            let authTokenObject = UserTokenGetObject(
                value: strongAuthToken,
                id: strongAuthTokenId
            )
            single(.success(authTokenObject))
            
            return Disposables.create()
        }
    }
}

extension KeychainWrapper.Key {
    static let authTokenId: KeychainWrapper.Key = "authTokenId"
    static let authToken: KeychainWrapper.Key = "authToken"
}

