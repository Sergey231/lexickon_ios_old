
import LexickonApi
import RxSwift

protocol UserTokenRepositoryProtocol {
    
    func get(
        with loginCredentials: UserCreateObject
    ) -> Single<UserTokenGetObject>
}
