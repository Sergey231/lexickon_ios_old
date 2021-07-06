//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 22.05.2021.
//

import Foundation
import LexickonApi

public struct WordEntity: Decodable {
    
    public let id: UUID
    public let studyWord: String
    public let translates: [String]
    public let updatingStudyRatingDate: Int?
    public let studyRating: Int
    public let image: String
    
    public init(
        id: UUID,
        studyWord: String,
        translates: [String],
        updatingStudyRatingDate: Int?,
        studyRating: Int,
        image: String
    ) {
        self.id = id
        self.studyWord = studyWord
        self.translates = translates
        self.updatingStudyRatingDate = updatingStudyRatingDate
        self.studyRating = studyRating
        self.image = image
    }
    
    public init(withLxWordList lxWord: LxWordList) {
        self.id = lxWord.id
        self.studyWord = lxWord.studyWord
        self.translates = lxWord.translates
        self.updatingStudyRatingDate = lxWord.updatingStudyRatingDate
        self.studyRating = lxWord.studyRating
        self.image = lxWord.image
    }
    
    public init(withLxWordGet lxWord: LxWordGet) {
        self.id = lxWord.id
        self.studyWord = lxWord.studyWord
        self.translates = lxWord.translates
        self.updatingStudyRatingDate = lxWord.updatingStudyRatingDate
        self.studyRating = lxWord.studyRating
        self.image = lxWord.image
    }
    
    // MARK: Test Implementation
    public var testStudyState: LxStudyState {
        if studyWord == "Cup" || studyWord == "Car" {
            return .fire
        } else if studyWord == "Knife" || studyWord == "dog" || studyWord == "cat" {
            return .ready
        } else if studyWord == "study" || studyWord == "keyboard" {
            return .new
        }
        return .waiting
    }
    
    public var studyState: LxStudyState {
        // 100% full Word Life Cycle Time Period (wordRating)
        // 70% waiting
        // 20% ready
        // 10% fire
        
        let now = Date().timeIntervalSince1970
        var result: LxStudyState = .fire
        let waitingPeriod = TimeInterval(updatingStudyRatingDate ?? Int(Date().timeIntervalSince1970))
        let readyPeriod: TimeInterval = waitingPeriod + (TimeInterval(studyRating) * 0.7)
        let firePeriod: TimeInterval = readyPeriod + (TimeInterval(studyRating) * 0.2)
        if studyRating == 0 {
            result = .new
        } else if now >= waitingPeriod && now < readyPeriod {
            result = .waiting
        } else if now >= readyPeriod && now < firePeriod {
            result = .ready
        } else if now >= firePeriod && now < TimeInterval(studyRating) {
            result = .fire
        }
        return result
    }
}
