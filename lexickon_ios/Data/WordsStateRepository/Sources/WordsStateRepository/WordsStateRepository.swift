
import RxSwift

public final class WordsStateRepository: WordsStateRepositoryProtocol {
    public func wordsState() -> Single<WordsState> {
        .empty()
    }
}
