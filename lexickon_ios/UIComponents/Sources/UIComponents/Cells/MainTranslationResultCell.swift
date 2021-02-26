//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 09.02.2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils
import RxDataSources
import UIExtensions
import Assets

public struct MainTranslationCellModel {
    
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

extension MainTranslationCellModel: Hashable {
    public static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.translation == rsh.translation
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(translation)
    }
}

extension MainTranslationCellModel: IdentifiableType {
    public var identity: String {
        return self.translation
    }
    public typealias Identity = String
}

public final class MainTranslationResultCell: DisposableTableViewCell {

    private let addWordButton = AddWordButton()
    private let wordRatingView = WordRatingView()
    private let translationLabel = UILabel()
    private let inLexickonStateView = InLexickonStateView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        addWordButton.setup {
            $0.setShadow()
            $0.configureTapScaleAnimation().disposed(by: disposeBag)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-Margin.mid)
                $0.size.equalTo(44)
                $0.centerY.equalToSuperview()
            }
        }
        
        wordRatingView.setup {
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(64)
                $0.top.equalToSuperview().offset(Margin.regular)
                $0.left.equalToSuperview().offset(Margin.regular)
            }
        }
        
        inLexickonStateView.setup {
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(wordRatingView.snp.right).offset(Margin.regular)
                $0.right.equalTo(addWordButton.snp.left).offset(-Margin.regular)
                $0.height.equalTo(16)
                $0.bottom.equalToSuperview().offset(-Margin.regular)
            }
        }
        
        translationLabel.setup {
            $0.numberOfLines = 0
            $0.textColor = Colors.baseText.color
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(wordRatingView.snp.right).offset(Margin.regular)
                $0.right.equalTo(addWordButton.snp.left).offset(-Margin.regular)
                $0.top.equalToSuperview().offset(Margin.regular)
                $0.height.greaterThanOrEqualTo(0)
                $0.bottom.equalTo(inLexickonStateView.snp.top).offset(-Margin.regular)
            }
        }
    }
    
    public func configurate(with model: MainTranslationCellModel) {
        
        wordRatingView.configure(input: WordRatingView.Input(rating: .just(1)))
        
        translationLabel.text = model.translation
        
        inLexickonStateView.configure(input: .init(state: .hasAsNewWord))
        
        addWordButton.rx.tap
            .asSignal()
            .emit(to: model.addWordButtonDidTapRelay)
            .disposed(by: disposeBag)
    }
}

extension MainTranslationResultCell: ClassIdentifiable {}
