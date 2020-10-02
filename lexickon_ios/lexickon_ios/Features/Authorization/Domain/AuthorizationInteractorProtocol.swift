
import RxSwift
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
    ) -> Single<Void>
    
    func restorePassword(login: String)
}
