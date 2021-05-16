
import LexickonApi
import RxSwift

public protocol UserRepositoryProtocol {
    
    func createUser(
        with credentials: LxUserCreate
    ) -> Single<LxUserGet>
}
