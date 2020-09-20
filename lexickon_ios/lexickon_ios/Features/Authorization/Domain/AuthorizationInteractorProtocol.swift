
import Combine
import LexickonApi

protocol AuthorizationInteractorProtocol {
    
    func registrate(
        name: String,
        email: String,
        password: String
    )
    
    func login(
        login: String,
        password: String
    ) -> AnyPublisher<UserTokenGetObject, HTTPObject.Error>
    
    func restorePassword(login: String)
}
