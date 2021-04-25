//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 07.02.2021.
//

import LexickonApi
import RxSwift
import Alamofire
import SwiftKeychainWrapper
import Foundation
import ApiRepository

public final class WordsRepositoryMock: WordsRepositoryProtocol, ApiRepository {
    
    public init() {}
    
    public func words(per: Int, page: Int) -> Single<LxPage<LxWordList>> {
        
        return Single.create { single -> Disposable in
            let model = LxPage<LxWordList>(
                metadata: .init(page: 0, per: 10, total: 10),
                items: self.words()
            )
            single(.success(model))
            return Disposables.create()
        }
    }
    
    public func word(by id: String) -> Single<LxWordGet> {
        Single.create { _ in Disposables.create() }
    }
    
    public func add(_ words: [LxWordCreate]) -> Single<[LxWordGet]> {
        Single.create { _ in Disposables.create() }
    }
    
    private func words() -> [LxWordList] {
        return [
            .init(
                id: UUID(uuidString: "3eab74a2-e1ba-4c73-a043-8f67f85ed70f")!,
                studyWord: "Cup",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "d5fcb089-4bf4-4c72-8661-b1eb0d20a2f0")!,
                studyWord: "Car",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "6325c134-e92b-4f0d-bf3d-56d830d8800d")!,
                studyWord: "Knife",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "21bab473-9c01-43a6-881b-69c21bddaa5e")!,
                studyWord: "dog",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "afa68285-4575-493b-a3ec-37e88d10d6eb")!,
                studyWord: "cat",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "faa7c7f6-93b0-40e5-a218-04734e946a87")!,
                studyWord: "study",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "faa7c7f6-93b0-40e5-a218-04734e946a87")!,
                studyWord: "keyboard",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "faa7c7f6-93b0-40e5-a218-04734e946a87")!,
                studyWord: "Spin",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "faa7c7f6-93b0-40e5-a218-04734e946a87")!,
                studyWord: "Good",
                translates: [],
                nextLessonDate: nil,
                image: ""
            ),
            .init(
                id: UUID(uuidString: "faa7c7f6-93b0-40e5-a218-04734e946a87")!,
                studyWord: "Hi",
                translates: [],
                nextLessonDate: nil,
                image: ""
            )
        ]
    }
}
