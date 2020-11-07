
import LexickonApi
import RxSwift

protocol UserRepositoryProtocol {
    
    func createUser(
        with credentials: UserCreateObject
    ) -> Single<UserGetObject>
}
