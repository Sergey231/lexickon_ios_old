//
//  AddSearchWordPresenter.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import RxSwift
import RxCocoa
import Resolver
import RxDataSources
import RxExtensions
import LexickonApi

typealias TranslationsSection = SectionModel<String, TranslationCellModelEnum>
typealias TranslationReulstRxDataSource = RxTableViewSectionedReloadDataSource<TranslationsSection>

final class AddSearchWordPresenter {
    
    @Injected private var addNewWordsUseCase: AddNewWordsUseCase
    @Injected private var translateUseCase: TranslateUseCase
    
    private let isEditModeRelay = BehaviorRelay<Bool>(value: false)
    fileprivate var selectedWordModels: [TranslationCellModelEnum] = []
    
    struct Input {
        let textForTranslate: Signal<String>
        let addToLexickonFromWordsEditPanelDidTap: Signal<Void>
    }
    
    struct Output {
        let sections: Driver<[TranslationsSection]>
        let isLoading: Driver<Bool>
        let disposables: CompositeDisposable
        let isEditMode: Driver<Bool>
        let wordsForDelete: Driver<[TranslationCellModelEnum]>
        let wordsForReset: Driver<[TranslationCellModelEnum]>
        let wordsForLearn: Driver<[TranslationCellModelEnum]>
        let wordsForEdding: Driver<[TranslationCellModelEnum]>
    }
    
    func configurate(input: Input) -> Output {
        
        let activityIndicator = RxActivityIndicator()
        let errorDetector = RxErrorProvider()
        
        let translationResult = input.textForTranslate
            .flatMapLatest { text -> Driver<TranslationResultsDTO> in
                self.translateUseCase.configure(TranslateUseCase.Input(text: text))
                    .translationResult
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .provideError(errorDetector)
            }
        
        let mainTranslationCellModels = translationResult
            .map { [unowned self] result -> [TranslationCellModelEnum] in
                [
                    TranslationCellModelEnum.Main(
                        MainTranslationCellModel(
                            translation: result.mainTranslation.translation,
                            text: result.mainTranslation.text,
                            isEditMode: self.isEditModeRelay.asDriver(),
                            studyState: LxStudyState.fire
                        )
                    )
                ]
            }
            .asDriver(onErrorJustReturn: [])
            
        let otherTranslationCellModels = translationResult
            .map { translationResult -> [TranslationCellModelEnum] in
                translationResult.otherTranslations.map {
                    TranslationCellModelEnum.Other(
                        OtherTranslationCellModel(
                            translation: $0.translation,
                            text: $0.text,
                            isEditMode: self.isEditModeRelay.asDriver(),
                            studyState: LxStudyState.fire
                        )
                    )
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let translationsSections = Driver.combineLatest(
            mainTranslationCellModels,
            otherTranslationCellModels
        )
            .map { [
                SectionModel(model: "MainTranslationSection", items: $0),
                SectionModel(model: "OtherTranslationSection", items: $1)
            ] }
        
        let translationModels = translationsSections
            .map { $0.flatMap { $0.items } }
        
        let wordForAddingFromWordCellButton = translationModels
            .flatMap {
                Signal.merge(
                    $0.map { cellModel -> Signal<TranslationCellModelEnum> in
                        switch cellModel {
                        
                        case .Main(let model):
                            return model.addWordButtonDidTap
                                .map { _ in cellModel }
                            
                        case .Other(let model):
                            return model.addWordButtonDidTap
                                .map { _ in cellModel }
                        }
                    }
                )
            }
        
        let wordSelectionStateDriver = translationModels
            .flatMap { words in
                Driver.merge( words.map { $0.wordSelectionStateDriver } )
            }
        
        let isEditMode = wordSelectionStateDriver
            .do(onNext: { wordModel in
                print("state: \(wordModel.wordSelectionState)")
                if wordModel.wordSelectionState == .selected {
                    self.selectedWordModels.append(wordModel)
                } else {
                    _ = self.selectedWordModels.remove(where: { selectedWordModel -> Bool in
                        selectedWordModel == wordModel
                    })
                }
            })
            .map { [unowned self] _ -> Bool in !self.selectedWordModels.isEmpty }

        let resetWordCellsSelectionDisposable = isEditMode.drive(isEditModeRelay)
        
        let isEditModeForOutput = Driver.merge(
            isEditModeRelay.asDriver(),
            isEditMode
        )
        
        let wordsForDelete = wordSelectionStateDriver
            .map { [unowned self] _ -> [TranslationCellModelEnum] in
                self.selectedWordModels
            }
        
        let wordsForReset = wordSelectionStateDriver
            .map { [unowned self] _ -> [TranslationCellModelEnum] in
                self.selectedWordModels.filter { $0.canBeReseted }
            }
        
        let wordsForLearn = wordSelectionStateDriver
            .map { [unowned self] _ -> [TranslationCellModelEnum] in
                self.selectedWordModels.filter { $0.canBeLearnt }
            }
        
        let wordsForEdding = wordSelectionStateDriver
            .map { [unowned self] _ -> [TranslationCellModelEnum] in
                self.selectedWordModels
            }
        
        let wordsForEddingFromEditPanel = input.addToLexickonFromWordsEditPanelDidTap
            .withLatestFrom(wordsForEdding)
        
        let wordsForAdding = Signal.merge(
            wordForAddingFromWordCellButton.map { [$0] },
            wordsForEddingFromEditPanel
        )
        
        let didTapAddWordDisposable = wordsForAdding
            .asObservable()
            .flatMap { wordModelsForAdding -> Single<Void> in
                let wordsTranslations = wordModelsForAdding.map { word in
                    TranslationResultsDTO.Translation(
                        text: word.text,
                        translation: word.translation,
                        pos: .unknown,
                        gender: .unknown
                    )
                }
                return self.addNewWordsUseCase.configure(
                    AddNewWordsUseCase.Input(
                        newWords: wordsTranslations
                    )
                )
                    .wordsDidAdded
            }
            .subscribe()
        
        let dispossables = CompositeDisposable(disposables: [
            resetWordCellsSelectionDisposable,
            didTapAddWordDisposable
        ])
        
        return Output(
            sections: translationsSections,
            isLoading: activityIndicator.asDriver(),
            disposables: dispossables,
            isEditMode: isEditModeForOutput,
            wordsForDelete: wordsForDelete,
            wordsForReset: wordsForReset,
            wordsForLearn: wordsForLearn,
            wordsForEdding: wordsForEdding
        )
    }
}

