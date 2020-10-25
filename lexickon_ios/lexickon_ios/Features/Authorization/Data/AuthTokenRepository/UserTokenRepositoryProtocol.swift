
import LexickonApi
import RxSwift

protocol AuthTokenRepositoryProtocol {
    
    func get(with credentiols: UserCreateObject) -> Single<UserTokenGetObject>
    var cach: Single<UserTokenGetObject> { get }
}
