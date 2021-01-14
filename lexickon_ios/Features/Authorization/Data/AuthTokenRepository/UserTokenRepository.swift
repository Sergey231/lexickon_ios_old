
import LexickonApi
import RxCocoa
import RxSwift
import Alamofire
import KeychainRepository
import Resolver

final class AuthTokenRepository: AuthTokenRepositoryProtocol, ApiRepository {
    
    @Injected private var KeychainRepository: KeychainRepositoryProtocol
    
    func get(with credentiols: LxUserCreate) -> Single<LxUserTokenGet> {
        
        let KeychainRepository = self.KeychainRepository
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
                        KeychainRepository.setObject(model.id, forKey: .authTokenId)
                        KeychainRepository.setObject(model.value, forKey: .authToken)
                        single(.success(model))
                    case .failure:
                        single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            
            return Disposables.create()
        }
    }
    
    func erasе() -> Single<Void> {
        let KeychainRepository = self.KeychainRepository
        return Single.create { single -> Disposable in
            KeychainRepository.removeObject(forKey: .authToken)
            KeychainRepository.removeObject(forKey: .authTokenId)
            single(.success(()))
            return Disposables.create()
        }
    }
    
    var cach: Single<LxUserTokenGet> {
        let KeychainRepository = self.KeychainRepository
        return Single.create { single -> Disposable in
            
            let authTokenId = KeychainRepository.object(forKey: .authTokenId)
            let authToken = KeychainRepository.object(forKey: .authToken)
            
            guard
                let strongAuthTokenId = authTokenId,
                let strongAuthToken = authToken
            else {
                single(.failure(LxHTTPObject.Error.unknown))
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
