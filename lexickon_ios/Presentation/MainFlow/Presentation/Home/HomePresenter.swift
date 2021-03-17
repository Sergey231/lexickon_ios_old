//
//  MainViewPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxDataSources
import RxCocoa
import LexickonApi
import RxDataSources
import Resolver
import LXControlKit
import RxExtensions

typealias HomeWordSectionModel = AnimatableSectionModel<String, HomeWordViewModel>
typealias HomeWordRxDataSource = RxTableViewSectionedAnimatedDataSource<HomeWordSectionModel>

final class HomePresenter {
    
    @Injected var mainInteractor: MainInteractorProtocol
    
    struct Input {
        let refreshData: Signal<Void>
        let needLoadNextWordsPage: Signal<Void>
    }
    
    struct Output {
        let isNextPageLoading: Driver<Bool>
        let isWordsUpdating: Driver<Bool>
        let sections: Driver<[HomeWordSectionModel]>
    }
    
    private var loadedWordsCount: Int = 10
    private var pagesCount: Int = 1
    private var didTap = PublishRelay<Void>()
    
    func configurate(input: Input) -> Output {
        
        let isNextPageLoading = RxActivityIndicator()
        let isWordsUpdating = RxActivityIndicator()
        
        let refreshedWords = input.refreshData
            .flatMapLatest { _ -> Driver<[LxWordList]> in
                self.mainInteractor.words(
                    per: 10,
                    page: 1
                )
                .map { $0.items }
                .trackActivity(isWordsUpdating)
                .asDriver(onErrorJustReturn: [])
                .do(onNext: { _ in
                    self.loadedWordsCount = 10
                    self.pagesCount = 1
                })
            }
        
        let words = input.needLoadNextWordsPage
            .startWith(())
            .flatMapLatest { _ -> Driver<[LxWordList]> in
                self.mainInteractor.words(
                    per: self.loadedWordsCount,
                    page: self.pagesCount
                )
                .map { $0.items }
                .trackActivity(isNextPageLoading)
                .asDriver(onErrorJustReturn: [])
                .do(onNext: {
                    self.loadedWordsCount += $0.count
                    self.pagesCount += 1
                })
            }
        
        let sections = Driver.merge(
            words,
            refreshedWords
        )
            .map { words -> [HomeWordSectionModel] in
                var fireWords: [HomeWordViewModel] = []
                var readyWords: [HomeWordViewModel] = []
                var newWords: [HomeWordViewModel] = []
                var waitingWords: [HomeWordViewModel] = []
                words.forEach {
                    switch $0.studyType {
                    case .fire:
                        fireWords.append(
                            HomeWordViewModel(
                                word: $0.studyWord,
                                studyType: .fire,
                                didTap: self.didTap
                            )
                        )
                    case .ready:
                        readyWords.append(
                            HomeWordViewModel(
                                word: $0.studyWord,
                                studyType: .ready,
                                didTap: self.didTap
                            )
                        )
                    case .new:
                        newWords.append(
                            HomeWordViewModel(
                                word: $0.studyWord,
                                studyType: .new,
                                didTap: self.didTap
                            )
                        )
                    case .waiting:
                        waitingWords.append(
                            HomeWordViewModel(
                                word: $0.studyWord,
                                studyType: .waiting,
                                didTap: self.didTap
                            )
                        )
                    }
                }
                
                var sections: [HomeWordSectionModel] = []
                
                if !fireWords.isEmpty {
                    let fireWordsSection = HomeWordSectionModel(
                        model: StudyType.fire.rawValue,
                        items: fireWords
                    )
                    sections.append(fireWordsSection)
                }
                
                if !readyWords.isEmpty {
                    let readyWordsSection = HomeWordSectionModel(
                        model: StudyType.ready.rawValue,
                        items: readyWords
                    )
                    sections.append(readyWordsSection)
                }
                
                if !newWords.isEmpty {
                    let newWordsSection = HomeWordSectionModel(
                        model: StudyType.new.rawValue,
                        items: newWords
                    )
                    sections.append(newWordsSection)
                }
                
                if !waitingWords.isEmpty {
                    let waitingWordsSection = HomeWordSectionModel(
                        model: StudyType.waiting.rawValue,
                        items: waitingWords
                    )
                    sections.append(waitingWordsSection)
                }
                
                return sections
            }
        
        
        
        let wordModels = sections
            .map { $0.flatMap { $0.items } }
        
//        didTap.asDriver(onErrorDriveWith: .empty()).debug("🎲").drive()
        
        didTap
            .withLatestFrom(wordModels)
            .map { words -> Bool in
                print("😀 \(words.map { wordModel in Unmanaged.passUnretained(wordModel).toOpaque() } )")
//                return words.reduce(false) { acc, wordModel -> Bool in
//                    var result = acc
//                    result = wordModel.wordSelectedState
//                    return result
//                }
                return false
            }
//            .debug("😀")
            .subscribe()
        
        return Output(
            isNextPageLoading: isNextPageLoading.asDriver(),
            isWordsUpdating: isWordsUpdating.asDriver(),
            sections: sections
        )
    }
}
