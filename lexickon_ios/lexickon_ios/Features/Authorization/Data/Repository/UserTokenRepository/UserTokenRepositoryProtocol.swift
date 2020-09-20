
import LexickonApi
import RxSwift

protocol UserTokenRepositoryProtocol {
    
    func get(with tokin: UserCreateObject) -> Single<UserTokenGetObject>
}
