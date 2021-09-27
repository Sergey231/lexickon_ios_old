
import LexickonApi
import RxSwift

public protocol AuthTokenRepositoryProtocol {
    
    func get(with credentiols: LxUserCreate) -> Single<LxUserTokenGet>
    func erasе() -> Single<Void>
    var cach: Single<LxUserTokenGet> { get }
}
