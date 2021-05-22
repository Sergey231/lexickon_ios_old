
import LexickonApi

public struct LexickonStateEntity {
    
    public enum State {
        case hasReadyWords
        case hasFireWords
        case waiating
        case empty
    }
    
    private let words: [LxWordList]
    
    init(words: [LxWordList]) {
        self.words = words
    }
    
    public var state: State {
        if !fireWords.isEmpty {
            return .hasFireWords
        } else if !readyWords.isEmpty {
            return .hasReadyWords
        } else if !words.isEmpty {
            return .waiating
        } else {
            return .empty
        }
    }
    
    var fireWords: [WordEntity] {
        words
            .filter { $0.studyType == .fire }
            .map { WordEntity(withLxWordList: $0) }
    }

    var readyWords: [WordEntity] {
        words
            .filter { $0.studyType == .ready }
            .map { WordEntity(withLxWordList: $0) }
    }

    var newWords: [WordEntity] {
        words
            .filter { $0.studyType == .new }
            .map { WordEntity(withLxWordList: $0) }
    }

    var waitingWords: [WordEntity] {
        words
            .filter { $0.studyType == .waiting }
            .map { WordEntity(withLxWordList: $0) }
    }
}
