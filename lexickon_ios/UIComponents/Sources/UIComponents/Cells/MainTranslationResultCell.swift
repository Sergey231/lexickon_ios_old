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

public struct MainTranslationResultViewModel {
    
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

extension MainTranslationResultViewModel: Hashable {
    public static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.translation == rsh.translation
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(translation)
    }
}

extension MainTranslationResultViewModel: IdentifiableType {
    public var identity: String {
        return self.translation
    }
    public typealias Identity = String
}

public final class MainTranslationResultCell: DisposableTableViewCell {
    
    private let translationLable = UILabel()
    private let addWordButton = AddWordToLesickonButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI(with input: MainTranslationResultViewModel) {
        
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
            $0.setTitle("+", for: .normal)
            $0.backgroundColor = Asset.Colors.mainBG.color
            $0.configureTapScaleAnimation().disposed(by: disposeBag)
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(40)
                $0.centerY.equalToSuperview()
            }
        }
    }
    
    public func configurate(with model: MainTranslationResultViewModel) {
        
        createUI(with: model)
        
        addWordButton.rx.tap
            .asSignal()
            .emit(to: model.addWordButtonDidTapRelay)
            .disposed(by: disposeBag)
    }
}

extension MainTranslationResultCell: ClassIdentifiable {}
