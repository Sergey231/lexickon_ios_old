//
//  MainViewPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxDataSources
import RxSwift
import RxCocoa
import LexickonApi
import RxDataSources
import Resolver
import RxExtensions

typealias HomeWordSectionModel = AnimatableSectionModel<String, HomeWordCellModel>
typealias HomeWordRxDataSource = RxTableViewSectionedAnimatedDataSource<HomeWordSectionModel>

final class HomePresenter {
    
    @Injected private var getStateUseCase: GetStateUseCase
    @Injected private var getWordsUseCase: GetWordsUseCase
    @Injected private var getWordsForExercise: GetWordsForExerciseUseCase
    @Injected private var creatExerciseSessionUseCase: CreatExerciseSessionUseCase
    
    private var wordsForLearn: [WordEntity] = []
    
    struct Input {
        let refreshData: Signal<Void>
        let needLoadNextWordsPage: Signal<Void>
        let learnWordsDidTap: Signal<Void>
    }
    
    struct Output {
        let isNextPageLoading: Driver<Bool>
        let isWordsUpdating: Driver<Bool>
        let sections: Driver<[HomeWordSectionModel]>
        let isEditMode: Driver<Bool>
        let wordsForDelete: Driver<[HomeWordCellModel]>
        let wordsForReset: Driver<[HomeWordCellModel]>
        let wordsForLearn: Driver<[HomeWordCellModel]>
        let lexickonState: Driver<LexickonStateEntity.State>
        let wordTap: Signal<WordEntity>
        let disposables: CompositeDisposable
    }
    
    private var loadedWordsCount = 10
    private var pagesCount = 1
    private let isEditModeRelay = BehaviorRelay<Bool>(value: false)
    
    private let oneMinuteTimer = Observable<Int>.interval(
        .seconds(60),
        scheduler: ConcurrentDispatchQueueScheduler(qos: .background)
    )
    
    private let oneHoureTimer = Observable<Int>.interval(
        .seconds(3600),
        scheduler: ConcurrentDispatchQueueScheduler(qos: .background)
    )
    .map { _ in () }
    .asSignal(onErrorSignalWith: .empty())
    
    fileprivate var selectedWordModels: [HomeWordCellModel] = []
    
    // MARK: Configure
    
    func configurate(input: Input) -> Output {
        
        getStateUseCase.configure(.init(updateState: .just(())))
            .state.debug("👨🏻")
            .drive()
        
        let isNextPageLoading = RxActivityIndicator()
        let isWordsUpdating = RxActivityIndicator()
        
        let refreshedWords = Signal.combineLatest(
            input.refreshData,
            oneHoureTimer
        ) { _, _ in () }
            .flatMapLatest { [unowned self] _ -> Driver<[WordEntity]> in
                getWordsUseCase.configure(GetWordsUseCase.Input(
                    per: 10,
                    page: 1
                ))
                    .words
                    .map { $0.items }
                    .trackActivity(isWordsUpdating)
                    .asDriver(onErrorJustReturn: [])
                    .do(onNext: { _ in
                        self.loadedWordsCount = 10
                        self.pagesCount = 1
                    })
            }
        
        let refreshDataResetSelectionStateDisposable = input.refreshData
            .do(onNext: { [unowned self] _ in
                self.selectedWordModels.removeAll()
            })
            .asDriver(onErrorDriveWith: .empty())
            .map { false }
            .drive(isEditModeRelay)
        
        let words = input.needLoadNextWordsPage
            .startWith(())
            .flatMapLatest { [unowned self] _ -> Driver<[WordEntity]> in
                getWordsUseCase.configure(GetWordsUseCase.Input(
                    per: loadedWordsCount,
                    page: pagesCount
                ))
                    .words
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
            .map { [unowned self] words -> [HomeWordSectionModel] in
                
                var fireWords: [HomeWordCellModel] = []
                var readyWords: [HomeWordCellModel] = []
                var newWords: [HomeWordCellModel] = []
                var waitingWords: [HomeWordCellModel] = []
                
                let updateWordStudyProgresEvent = oneMinuteTimer
                    .asSignal(onErrorSignalWith: .empty())
                    .mapTo(())
                
                words.forEach {
                    switch $0.studyState {
                    case .fire, .downgradeRating:
                        fireWords.append(
                            HomeWordCellModel(
                                wordEntity: $0,
                                isEditMode: isEditModeRelay.asDriver(),
                                updateWordStudyProgresEvent: updateWordStudyProgresEvent
                            )
                        )
                    case .ready:
                        readyWords.append(
                            HomeWordCellModel(
                                wordEntity: $0,
                                isEditMode: isEditModeRelay.asDriver(),
                                updateWordStudyProgresEvent: updateWordStudyProgresEvent
                            )
                        )
                    case .new:
                        newWords.append(
                            HomeWordCellModel(
                                wordEntity: $0,
                                isEditMode: isEditModeRelay.asDriver(),
                                updateWordStudyProgresEvent: updateWordStudyProgresEvent
                            )
                        )
                    case .waiting:
                        waitingWords.append(
                            HomeWordCellModel(
                                wordEntity: $0,
                                isEditMode: isEditModeRelay.asDriver(),
                                updateWordStudyProgresEvent: updateWordStudyProgresEvent
                            )
                        )
                    }
                }
                
                var sections: [HomeWordSectionModel] = []
                
                if !fireWords.isEmpty {
                    let fireWordsSection = HomeWordSectionModel(
                        model: LxStudyState.fire.rawValue,
                        items: fireWords
                    )
                    sections.append(fireWordsSection)
                }
                
                if !readyWords.isEmpty {
                    let readyWordsSection = HomeWordSectionModel(
                        model: LxStudyState.ready.rawValue,
                        items: readyWords
                    )
                    sections.append(readyWordsSection)
                }
                
                if !newWords.isEmpty {
                    let newWordsSection = HomeWordSectionModel(
                        model: LxStudyState.new.rawValue,
                        items: newWords
                    )
                    sections.append(newWordsSection)
                }
                
                if !waitingWords.isEmpty {
                    let waitingWordsSection = HomeWordSectionModel(
                        model: LxStudyState.waiting.rawValue,
                        items: waitingWords
                    )
                    sections.append(waitingWordsSection)
                }
                
                return sections
            }
        
        let wordModels = sections
            .map { $0.flatMap { $0.items } }
        
        let wordSelectionStateDriver = wordModels
            .flatMap { words in
                Driver.merge( words.map { $0.wordSelectionStateDriver } )
            }
        
        let wordTapSignal = wordModels
            .flatMap { wordCellModels -> Signal<WordEntity> in
                Signal.merge(
                    wordCellModels.map { wordCellModel in
                        wordCellModel.tapWithoutEditMode.map { _ in wordCellModel.wordEntity }
                    }
                )
            }
        
        let isEditMode = wordSelectionStateDriver
            .do(onNext: { [unowned self] wordModel in
                if wordModel.wordSelectionState == .selected {
                    selectedWordModels.append(wordModel)
                } else {
                    _ = selectedWordModels.remove(where: { selectedWordModel -> Bool in
                        selectedWordModel == wordModel
                    })
                }
            })
            .map { [unowned self] _ -> Bool in !selectedWordModels.isEmpty }
        
        let wordsForDelete = wordSelectionStateDriver
            .map { [unowned self] _ -> [HomeWordCellModel] in
                selectedWordModels
            }
        
        let wordsForReset = wordSelectionStateDriver
            .map { [unowned self] _ -> [HomeWordCellModel] in
                selectedWordModels.filter { $0.studyState.canBeReseted }
            }
        
        let wordsForLearn = wordSelectionStateDriver
            .map { [unowned self] _ -> [HomeWordCellModel] in
                selectedWordModels.filter { $0.studyState.canBeLearnt }
            }
            .do(onNext: { [unowned self] in
                self.wordsForLearn = $0.map { $0.wordEntity }
            })
        
        _ = input.learnWordsDidTap
            .flatMapLatest { [unowned self] _ -> Signal<Void> in
                self.creatExerciseSessionUseCase.configure(
                    CreatExerciseSessionUseCase.Input(words: self.wordsForLearn)
                )
                    .session
                    .map { _ in () }
                    .asSignal(onErrorSignalWith: .empty())
            }
            .emit()

        
        let resetWordCellsSelectionDisposable = isEditMode.drive(isEditModeRelay)
        
        let isEditModeForOutput = Driver.merge(
            isEditMode,
            isEditModeRelay.asDriver()
        )
        
        let disposables = CompositeDisposable(disposables: [
            resetWordCellsSelectionDisposable,
            refreshDataResetSelectionStateDisposable
        ])
        
        return Output(
            isNextPageLoading: isNextPageLoading.asDriver(),
            isWordsUpdating: isWordsUpdating.asDriver(),
            sections: sections,
            isEditMode: isEditModeForOutput,
            wordsForDelete: wordsForDelete,
            wordsForReset: wordsForReset,
            wordsForLearn: wordsForLearn.debug("🤩"),
            lexickonState: .just(LexickonStateEntity.State.hasFireWords),
            wordTap: wordTapSignal,
            disposables: disposables
        )
    }
}
