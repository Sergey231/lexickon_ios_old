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
import Assets

public struct OtherTranslationCellModel {
    
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

extension OtherTranslationCellModel: Hashable {
    public static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.translation == rsh.translation
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(translation)
    }
}

extension OtherTranslationCellModel: IdentifiableType {
    public var identity: String {
        return self.translation
    }
    public typealias Identity = String
}

public final class TranslationResultCell: DisposableTableViewCell {
    
    private let wordRaitingView = WordRatingView()
    private let translationLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI(with input: OtherTranslationCellModel) {
        
        wordRaitingView.setup {
            contentView.addSubview($0)
            $0.configure(input: WordRatingView.Input(rating: .just(1)))
            $0.snp.makeConstraints {
                $0.size.equalTo(34)
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.top.equalToSuperview().offset(Margin.small)
            }
        }
        
        translationLable.setup {
            $0.numberOfLines = 0
            $0.font = .systemRegular14
            $0.text = input.translation
            $0.textColor = Asset.Colors.baseText.color
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(wordRaitingView.snp.right).offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.centerY.equalToSuperview()
                $0.height.equalTo(21)
            }
        }
    }
    
    public func configurate(with model: OtherTranslationCellModel) {
        
        createUI(with: model)
        
        
    }
}

extension TranslationResultCell: ClassIdentifiable {}

