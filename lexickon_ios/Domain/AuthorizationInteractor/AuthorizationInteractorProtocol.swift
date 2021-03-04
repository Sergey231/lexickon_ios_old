
import RxSwift
import LexickonApi

protocol AuthorizationInteractorProtocol {
    
    func registrate(
        name: String,
        email: String,
        password: String
    ) -> Single<Void>
    
    func login(
        login: String,
        password: String
    ) -> Single<Void>
    
    var hasAuthToken: Single<Bool> { get }
    func restorePassword(login: String)
}
