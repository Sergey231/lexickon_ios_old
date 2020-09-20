
import LexickonApi
import RxSwift

protocol UserRepositoryProtocol {
    
    func createUser(with credentions: UserCreateObject) -> Single<UserGetObject>
}
