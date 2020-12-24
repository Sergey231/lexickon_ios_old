
import RxSwift
import LexickonApi
import Resolver

final class AuthorizationInteractor {
    @Injected var userTokenRepository: AuthTokenRepositoryProtocol
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
        
        return userTokenRepository.get(with: userCredantions)
            .map { _ in () }
    }
    
    var hasAuthToken: Single<Bool> {
        userTokenRepository.cach
            .map { _ -> Bool in true }
            .catchErrorJustReturn(false)
    }
    
    func restorePassword(login: String) {
        
    }
}
