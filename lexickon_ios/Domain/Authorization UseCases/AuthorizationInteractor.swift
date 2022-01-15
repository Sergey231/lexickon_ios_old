import RxSwift
import LexickonApi
import Resolver

final class AuthorizationInteractor {
    @Injected var authTokenRepository: AuthTokenRepositoryProtocol
    @Injected var userRepository: UserRepositoryProtocol
}

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    
    func registrate(
        name: String,
        email: String,
        password: String
    ) -> Single<Void> {
        
        let userCreateObject = LxUserCreate(
            email: email,
            password: password
        )
        
        return userRepository.createUser(with: userCreateObject)
            .map { _ in () }
    }
    
    func login(
        login: String,
        password: String
    ) -> Single<Void> {
        
        let userCredantions = LxUserCreate(
            email: login,
            password: password
        )
        
        return authTokenRepository.get(with: userCredantions)
            .map { _ in () }
    }
    
    var hasAuthToken: Single<Bool> {
        authTokenRepository.cach
            .map { _ -> Bool in true }
            .catchAndReturn(false)
    }
    
    func restorePassword(login: String) {
        
    }
}
