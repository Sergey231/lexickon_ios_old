
import LexickonApi

public struct LexickonStateEntity {
    
    public enum State {
        case hasReadyWords
        case hasFireWords
        case waiating
        case empty
    }
    
    let fireWordsCount: UInt
    let readyWordsCount: UInt
    let newWordsCount: UInt
    let waitingWordsCount: UInt
    
    init(
        fireWordsCount: UInt,
        readyWordsCount: UInt,
        newWordsCount: UInt,
        waitingWordsCount: UInt
    ) {
        self.fireWordsCount = fireWordsCount
        self.readyWordsCount = readyWordsCount
        self.newWordsCount = newWordsCount
        self.waitingWordsCount = waitingWordsCount
    }
    
    public var state: State {
        if fireWordsCount != 0 {
            return .hasFireWords
        } else if readyWordsCount != 0 {
            return .hasReadyWords
        } else if waitingWordsCount != 0 {
            return .waiating
        } else {
            return .empty
        }
    }
}
