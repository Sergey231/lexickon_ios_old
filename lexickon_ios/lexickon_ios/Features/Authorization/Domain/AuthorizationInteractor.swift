
import RxSwift
import LexickonApi

final class AuthorizationInteractor {
    
    let userTokenRepository: AuthTokenRepositoryProtocol
    let userRepository: UserRepositoryProtocol
    
    init(
        userTokenRepository: AuthTokenRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.userTokenRepository = userTokenRepository
        self.userRepository = userRepository
    }
}

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    
    func registrate(
        name: String,
        email: String,
        password: String
    ) -> Single<Void> {
        
        let userCreateObject = UserCreateObject(
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
        
        let userCredantions = UserCreateObject(
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
