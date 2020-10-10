
import LexickonApi
import Combine

protocol UserRepositoryProtocol {
    
    func createUser(
        with credentions: UserCreateObject
    ) -> AnyPublisher<UserGetObject, HTTPObject.Error>
}
