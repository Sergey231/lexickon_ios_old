//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 22.05.2021.
//

import Foundation
import LexickonApi
import UIKit

public struct WordEntity: Decodable {
    
    public let id: UUID
    public let studyWord: String
    public let translates: [String]
    public let updatingStudyRatingDate: Int?
    public var studyRating: Int
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
        self.updatingStudyRatingDate = Int(lxWord.updatingStudyRatingDate ?? 0)
        self.studyRating = Int(lxWord.studyRating)
        self.image = lxWord.image
    }
    
    public init(withLxWordGet lxWord: LxWordGet) {
        self.id = lxWord.id
        self.studyWord = lxWord.studyWord
        self.translates = lxWord.translates
        self.updatingStudyRatingDate = Int(lxWord.updatingStudyRatingDate ?? 0)
        self.studyRating = Int(lxWord.studyRating)
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
        let startOfDowngrateRatingPeriod = 1.0

        // 70% waiting
        let startOfWaitingPeriod = 0.0
        
        // 20% ready
        let startOfReadyPeriod = 0.7
        
        // 10% fire
        let startOfFirePeriod = 0.9
        
        let currentStudyPercent = studyStatePercent
        var result: LxStudyState = .fire
        if studyRating == 0 {
            result = .new
        } else if currentStudyPercent >= startOfWaitingPeriod &&
                    currentStudyPercent < startOfReadyPeriod {
            result = .waiting
        } else if currentStudyPercent >= startOfReadyPeriod &&
                    currentStudyPercent < startOfFirePeriod {
            result = .ready
        } else if currentStudyPercent >= startOfFirePeriod &&
                    currentStudyPercent < startOfDowngrateRatingPeriod {
            result = .fire
        } else if currentStudyPercent >= startOfDowngrateRatingPeriod {
            result = .downgradeRating
        }
        return result
    }
    
    public var studyStatePercent: Double {
        let now = Date().timeIntervalSince1970
        let waitingPeriod = Double(updatingStudyRatingDate ?? Int(Date().timeIntervalSince1970))
        let resultTimeInterval = now - waitingPeriod
        let onePersent = Double(studyRating)/100
        let resultPersent = (resultTimeInterval/onePersent)/100
        let oneSafeResult = resultPersent > 1 ? 1 : resultPersent
        let result = oneSafeResult < 0 ? 0 : oneSafeResult
        return result
    }
    
    public mutating func updateStudyRating(
        exerciseType: ExercisesSessionEntity.ExerciseType,
        exerciseResultRatingAmount: CGFloat // от 0.9 до 1
    ) {
        switch exerciseType {
            
        case .wordView:
            // повышаем рейтинг знания слова
            let newStudyRating: CGFloat = CGFloat(difficultyRating) * exerciseResultRatingAmount
            studyRating = Int(newStudyRating)
        case .none:
            // повышаем рейтинг правописания
            break
        }
    }
    
    private var difficultyRating: Int {
        // Пока так, а там посмотрим.
        let syllablesCount = SwiftSyllables.getSyllables(studyWord)
        let defficulty = syllablesCount * studyWord.count
        return defficulty
    }
}
