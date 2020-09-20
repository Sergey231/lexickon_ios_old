
import Combine
import LexickonApi

final class AuthorizationInteractor {
    
    let userTokenRepository: UserTokenRepositoryProtocol
    
    init(userTokenRepository: UserTokenRepositoryProtocol) {
        self.userTokenRepository = userTokenRepository
    }
}

extension AuthorizationInteractor: AuthorizationInteractorProtocol {
    
    func registrate(name: String, email: String, password: String) {
        
    }
    
    func login(
        login: String,
        password: String
    ) -> AnyPublisher<UserTokenGetObject, HTTPObject.Error> {
        let userCredantions = UserCreateObject(
            email: login,
            password: password
        )
        return userTokenRepository.get(with: userCredantions)
    }
    
    func restorePassword(login: String) {
        
    }
}
