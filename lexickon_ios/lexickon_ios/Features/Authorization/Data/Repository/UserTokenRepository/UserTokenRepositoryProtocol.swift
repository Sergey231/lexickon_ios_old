
import LexickonApi
import Combine

protocol UserTokenRepositoryProtocol {
    
    func get(
        with tokin: UserCreateObject
    ) -> AnyPublisher<UserTokenGetObject, HTTPObject.Error>
}
