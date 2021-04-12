//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 11.04.2021.
//

import RxCocoa

public enum TranslationCell {
    
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
    
    public var wordSelectionStateDriver: Driver<TranslationCell> {
        switch self {
        case .Main(let mainTranslationCellModel):
            return mainTranslationCellModel.wordSelectionStateDriver
                .map { TranslationCell.Main($0) }
        case .Other(let otherTranslationCellModel):
            return otherTranslationCellModel.wordSelectionStateDriver
                .map { TranslationCell.Other($0) }
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
}

extension TranslationCell: Equatable {
    
    public static func == (lhs: TranslationCell, rhs: TranslationCell) -> Bool {
        lhs.text == rhs.text && lhs.translation == rhs.translation
    }
}
