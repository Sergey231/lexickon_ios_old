//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 11.04.2021.
//

import RxCocoa

public enum TranslationCellModelEnum {
    
    public enum SelectionState {
        case selected
        case notSelected
        case none
    }
    
    case Main(MainTranslationCellModel)
    case Other(OtherTranslationCellModel)
    
    public var text: String {
        switch self {
        case .Main(let model):
            return model.text
        case .Other(let model):
            return model.text
        }
    }
    
    public var translation: String {
        switch self {
        case .Main(let model):
            return model.translation
        case .Other(let model):
            return model.translation
        }
    }
    
    public var wordSelectionStateDriver: Driver<TranslationCellModelEnum> {
        switch self {
        case .Main(let mainTranslationCellModel):
            return mainTranslationCellModel.wordSelectionStateDriver
                .map { TranslationCellModelEnum.Main($0) }
        case .Other(let otherTranslationCellModel):
            return otherTranslationCellModel.wordSelectionStateDriver
                .map { TranslationCellModelEnum.Other($0) }
        }
    }
    
    public var wordSelectionState: SelectionState {
        switch self {
        case .Main(let mainTranslationCellModel):
            return mainTranslationCellModel.wordSelectionState
        case .Other(let otherTranslationCellModel):
            return otherTranslationCellModel.wordSelectionState
        }
    }
    
    public var canBeReseted: Bool {
        switch self {
        case .Main(let mainTranslationCellModel):
            return mainTranslationCellModel.studyState.canBeReseted
        case .Other(let otherTranslationCellModel):
            return otherTranslationCellModel.studyState.canBeReseted
        }
    }
    
    public var canBeLearnt: Bool {
        switch self {
        case .Main(let mainTranslationCellModel):
            return mainTranslationCellModel.studyState.canBeLearnt
        case .Other(let otherTranslationCellModel):
            return otherTranslationCellModel.studyState.canBeLearnt
        }
    }
}

extension TranslationCellModelEnum: Equatable {
    
    public static func == (lhs: TranslationCellModelEnum, rhs: TranslationCellModelEnum) -> Bool {
        lhs.text == rhs.text && lhs.translation == rhs.translation
    }
}
