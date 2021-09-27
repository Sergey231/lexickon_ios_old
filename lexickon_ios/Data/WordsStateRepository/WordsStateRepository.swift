// import ApiRepository
import LexickonApi
import RxSwift

public final class WordsStateRepository: WordsStateRepositoryProtocol, ApiRepository {
   
    public init() {}
    
    public func wordsState() -> Single<LxWordsState> {
        
        let url = baseURL + "/api/wordsState"
        let session = LxSessionManager.shared.session
        
        return Single.create { single -> Disposable in
            
            session.request(url)
                .responseDecodable(
                    of: LxWordsState.self,
                    decoder: self.jsonDecoder
                ) { res in
                    
                    switch res.result {
                    case .success(let model):
                        single(.success(model))
                    case .failure:
                        single(.failure(LxHTTPObject.Error(with: res.response?.statusCode)))
                    }
                }
            
            return Disposables.create()
        }
    }
}
