
import LexickonApi
import RxSwift

protocol UserTokenRepositoryProtocol {
    
    func get(with credentiols: UserCreateObject) -> Single<UserTokenGetObject>
}
