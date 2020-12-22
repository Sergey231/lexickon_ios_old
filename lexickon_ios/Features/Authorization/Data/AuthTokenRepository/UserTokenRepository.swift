
import LexickonApi
import RxCocoa
import RxSwift
import Alamofire
import SwiftKeychainWrapper

final class AuthTokenRepository: AuthTokenRepositoryProtocol, ApiRepository {
    
    private let keychain = KeychainWrapper.standard
    
    func get(with credentiols: LxUserCreate) -> Single<LxUserTokenGet> {
        
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
                .responseDecodable(of: LxUserTokenGet.self) { res in
                    switch res.result {
                    case .success(let model):
                        keychain[.authTokenId] = model.id
                        keychain[.authToken] = model.value
                        single(.success(model))
                    case .failure:
                        single(.error(LxHTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func erasе() -> Single<Void> {
        let keychain = self.keychain
        return Single.create { single -> Disposable in
            keychain.remove(forKey: .authToken)
            keychain.remove(forKey: .authTokenId)
            single(.success(()))
            return Disposables.create()
        }
    }
    
    var cach: Single<LxUserTokenGet> {
        let keychain = self.keychain
        return Single.create { single -> Disposable in
            
            let authTokenId: String? = keychain[.authTokenId]
            let authToken: String? = keychain[.authToken]
            
            guard
                let strongAuthTokenId = authTokenId,
                let strongAuthToken = authToken
            else {
                single(.error(LxHTTPObject.Error.unknown))
                return Disposables.create()
            }
            
            let authTokenObject = LxUserTokenGet(
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

