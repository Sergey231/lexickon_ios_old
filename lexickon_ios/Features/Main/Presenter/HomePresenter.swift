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
import UIComponents

typealias HomeWordSectionModel = AnimatableSectionModel<String, HomeWordViewModel>
typealias HomeWordRxDataSource = RxTableViewSectionedAnimatedDataSource<HomeWordSectionModel>

final class HomePresenter: PresenterType {
    
    @Injected var mainInteractor: MainInteractorProtocol
    
    struct Input {
        let refreshData: Signal<Void>
        let needLoadNextWordsPage: Signal<Void>
    }
    
    struct Output {
        let sections: Driver<[HomeWordSectionModel]>
    }
    
    private var loadedWordsCount: Int = 10
    private var pagesCount: Int = 1
    
    func configurate(input: Input) -> Output {
        
        let refreshedWords = input.refreshData
            .flatMapLatest { _ -> Driver<[LxWordList]> in
                self.mainInteractor.words(
                    per: 10,
                    page: 1
                )
                .map { $0.items }
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
                        fireWords.append(HomeWordViewModel(word: $0.studyWord, studyType: .fire))
                    case .ready:
                        readyWords.append(HomeWordViewModel(word: $0.studyWord, studyType: .ready))
                    case .new:
                        newWords.append(HomeWordViewModel(word: $0.studyWord, studyType: .new))
                    case .waiting:
                        waitingWords.append(HomeWordViewModel(word: $0.studyWord, studyType: .waiting))
                    }
                }
                
                var sections: [HomeWordSectionModel] = []
                
                if !fireWords.isEmpty {
                    let fireWordsSection = HomeWordSectionModel(
                        model: "fire",
                        items: fireWords
                    )
                    sections.append(fireWordsSection)
                }
                
                if !readyWords.isEmpty {
                    let readyWordsSection = HomeWordSectionModel(
                        model: "ready",
                        items: readyWords
                    )
                    sections.append(readyWordsSection)
                }
                
                if !newWords.isEmpty {
                    let newWordsSection = HomeWordSectionModel(
                        model: "new",
                        items: newWords
                    )
                    sections.append(newWordsSection)
                }
                
                if !waitingWords.isEmpty {
                    let waitingWordsSection = HomeWordSectionModel(
                        model: "waiting",
                        items: waitingWords
                    )
                    sections.append(waitingWordsSection)
                }
                
                return sections
            }
        
        return Output(sections: sections)
    }
}
