
import LexickonApi
import RxSwift

protocol AuthTokenRepositoryProtocol {
    
    func get(with credentiols: UserCreateObject) -> Single<UserTokenGetObject>
    func erasе() -> Single<Void>
    var cach: Single<UserTokenGetObject> { get }
}
