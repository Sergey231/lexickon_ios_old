
import LexickonApi
import RxCocoa
import RxSwift

protocol UserRepositoryProtocol {
    
    func createUser(
        with credentials: UserCreateObject
    ) -> Single<UserGetObject>
}
