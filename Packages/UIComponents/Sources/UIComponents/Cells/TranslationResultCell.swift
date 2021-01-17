//
//  TranslationResultCell.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 07.01.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils
import RxDataSources
import UIExtensions

public struct TranslationResultViewModel {
    
    fileprivate let addWordButtonDidTapRelay = PublishRelay<Void>()
    public var addWordButtonDidTap: Signal<Void> {
        addWordButtonDidTapRelay.asSignal()
    }
    
    public init(
        translation: String,
        text: String
    ) {
        self.translation = translation
        self.text = text
    }
    public let translation: String
    public let text: String
}

extension TranslationResultViewModel: Hashable {
    public static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.translation == rsh.translation
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(translation)
    }
}

extension TranslationResultViewModel: IdentifiableType {
    public var identity: String {
        return self.translation
    }
    public typealias Identity = String
}

public final class TranslationResultCell: DisposableTableViewCell {
    
    private let translationLable = UILabel()
    private let addWordButton = AddWordToLesickonButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI(with input: TranslationResultViewModel) {
        
        translationLable.setup {
            $0.font = .systemRegular17
            $0.text = input.translation
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalToSuperview().offset(Margin.regular)
                $0.height.equalTo(Size.textField.height)
            }
        }
        
        addWordButton.setup {
            $0.setTitle("+ в мой Lexickon", for: .normal)
            $0.configureTapScaleAnimation().disposed(by: disposeBag)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(translationLable.snp.bottom).offset(Margin.regular)
                $0.height.equalTo(Size.button.height)
                $0.bottom.equalToSuperview().offset(-Margin.regular)
            }
        }
    }
    
    public func configurate(with model: TranslationResultViewModel) {
        
        createUI(with: model)
        
        addWordButton.rx.tap
            .asSignal()
            .emit(to: model.addWordButtonDidTapRelay)
            .disposed(by: disposeBag)
    }
}

extension TranslationResultCell: ClassIdentifiable {}

