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
    public let nextLessonDate: Date?
    public let image: String
    
    public init(
        id: UUID,
        studyWord: String,
        translates: [String],
        nextLessonDate: Date?,
        image: String
    ) {
        self.id = id
        self.studyWord = studyWord
        self.translates = translates
        self.nextLessonDate = nextLessonDate
        self.image = image
    }
    
    public init(withLxWordList lxWord: LxWordList) {
        self.id = lxWord.id
        self.studyWord = lxWord.studyWord
        self.translates = lxWord.translates
        self.nextLessonDate = lxWord.nextLessonDate
        self.image = lxWord.image
    }
    
    public init(withLxWordGet lxWord: LxWordGet) {
        self.id = lxWord.id
        self.studyWord = lxWord.studyWord
        self.translates = lxWord.translates
        self.nextLessonDate = lxWord.nextLessonDate
        self.image = lxWord.image
    }
    
    // MARK: Test Implementation
    public var studyType: StudyType {
        if studyWord == "Cup" || studyWord == "Car" {
            return .fire
        } else if studyWord == "Knife" || studyWord == "dog" || studyWord == "cat" {
            return .ready
        } else if studyWord == "study" || studyWord == "keyboard" {
            return .new
        }
        return .waiting
    }
}