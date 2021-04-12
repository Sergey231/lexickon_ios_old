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
import LXControlKit
import RxExtensions
import TranslationRepository

typealias TranslationsSection = SectionModel<String, TranslationCell>
typealias TranslationReulstRxDataSource = RxTableViewSectionedReloadDataSource<TranslationsSection>

final class AddSearchWordPresenter {
    
    @Injected var interacor: NewWordInteractorProtocol
    private let isEditModeRelay = BehaviorRelay<Bool>(value: false)
    fileprivate var selectedWordModels: [TranslationCell] = []
    
    struct Input {
        let textForTranslate: Signal<String>
    }
    
    struct Output {
        let sections: Driver<[TranslationsSection]>
        let isLoading: Driver<Bool>
        let disposables: CompositeDisposable
        let isEditMode: Driver<Bool>
    }
    
    func configurate(input: Input) -> Output {
        
        let activityIndicator = RxActivityIndicator()
        let errorDetector = RxErrorProvider()
        
        let translationResult = input.textForTranslate
            .flatMapLatest { text -> Driver<TranslationResultsDTO> in
                self.interacor.translate(text)
                    .asObservable()
                    .trackActivity(activityIndicator)
                    .provideError(errorDetector)
            }
        
        let mainTranslationCellModels = translationResult
            .map { [unowned self] result -> [TranslationCell] in
                [
                    TranslationCell.Main(
                        MainTranslationCellModel(
                            translation: result.mainTranslation.translation,
                            text: result.mainTranslation.text,
                            isEditMode: self.isEditModeRelay.asDriver()
                        )
                    )
                ]
            }
            .asDriver(onErrorJustReturn: [])
            
        let otherTranslationCellModels = translationResult
            .map { translationResult -> [TranslationCell] in
                translationResult.otherTranslations.map {
                    TranslationCell.Other(
                        OtherTranslationCellModel(
                            translation: $0.translation,
                            text: $0.text,
                            isEditMode: self.isEditModeRelay.asDriver()
                        )
                    )
                }
            }
            .asDriver(onErrorJustReturn: [])
        
        let didTapAddWord = otherTranslationCellModels
            .flatMap {
                Signal.merge(
                    $0.map { cellModel -> Signal<TranslationCell> in
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
        
        let didTapAddWordDisposable = didTapAddWord
            .asObservable()
            .flatMap { word -> Single<Void> in
                let wordForAdding = TranslationResultsDTO.Translation(
                    text: word.text,
                    translation: word.translation,
                    pos: .unknown,
                    gender: .unknown
                )
                
                return self.interacor.addWord(wordForAdding)
            }
            .subscribe()
        
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
        
        return Output(
            sections: translationsSections,
            isLoading: activityIndicator.asDriver(),
            disposables: CompositeDisposable(disposables: [didTapAddWordDisposable]),
            isEditMode: isEditMode
        )
    }
}

