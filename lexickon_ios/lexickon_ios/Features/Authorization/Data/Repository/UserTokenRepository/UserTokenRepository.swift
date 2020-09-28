
import Foundation
import LexickonApi
import RxSwift
import RxAlamofire

final class UserTokenRepository: UserTokenRepositoryProtocol, ApiRepository {
    
    func get(with loginCredentials: UserCreateObject) -> Single<UserTokenGetObject> {
        
        let urlResource = URL(string: "\(baseURL)/api/user/login")!
        let parametrs = ["email": loginCredentials.email, "password": loginCredentials.hashedPassword]
        
        return Single<UserTokenGetObject>.create { single -> Disposable in
            
            _ = RxAlamofire.requestJSON(
                .post,
                urlResource,
                parameters: parametrs
            )
            .asSingle()
            .subscribe(
                onSuccess: { response in
                    switch response.0.statusCode {
                    case 200..<300:
                        single(.success(response.1 as! PrimitiveSequence<SingleTrait, UserTokenGetObject>.Element))
                    case 401:
                        single(.error(HTTPObject.Error.unauthorized))
                    default:
                        single(.error(HTTPObject.Error.unauthorized))
                    }
                }, onError: { single(.error($0)) }
            )
            
            return Disposables.create()
        }
        
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
        
//        return .just(UserTokenGetObject(value: "", userId: ""))
    }
}
