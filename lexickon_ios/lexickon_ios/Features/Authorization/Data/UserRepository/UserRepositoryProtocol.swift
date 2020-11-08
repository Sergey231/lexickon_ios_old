
import LexickonApi
import RxSwift

protocol UserRepositoryProtocol {
    
    func createUser(
        with credentials: LxUserCreate
    ) -> Single<LxUserGet>
}
