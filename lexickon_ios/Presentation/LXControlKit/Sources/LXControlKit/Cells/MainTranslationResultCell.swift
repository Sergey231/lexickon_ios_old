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

// MARK: Cell Model

public struct MainTranslationCellModel {
    
    public enum SelectionState {
        case selected
        case notSelected
        case none
    }
    
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
    
    fileprivate var wordSelectionStateChangedRelay = PublishRelay<Void>()
    public var wordSelectionState: SelectionState = .none
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

// MARK: Table View Cell

public final class MainTranslationResultCell: DisposableTableViewCell {

    fileprivate var model: MainTranslationCellModel!
    
    private let scrollView = UIScrollView()
    private let swipeContentView = UIView()
    fileprivate let selectionIcon = CheckBox()
    
    private let addWordButton = AddWordButton()
    private let wordRatingView = WordRatingView()
    private let translationLabel = UILabel()
    private let inLexickonStateView = InLexickonStateView()
    
    private var lastX: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Create UI
    
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
        
        selectionIcon.setup {
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalTo(18)
                $0.width.equalTo(46)
            }
        }
        
        scrollView.setup {
            $0.delegate = self
            $0.alwaysBounceHorizontal = true
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        swipeContentView.setup {
            scrollView.addSubview($0)
            $0.snp.remakeConstraints { [unowned self] in
                $0.height.greaterThanOrEqualTo(self.contentView.snp.height)
                $0.width.greaterThanOrEqualTo(self.contentView.snp.width)
                $0.edges.equalToSuperview()
            }
        }
    }
    
    // MARK: Configurate Cell
    
    public func configurate(with model: MainTranslationCellModel) {
        
        wordRatingView.configure(input: WordRatingView.Input(rating: .just(1)))
        
        translationLabel.text = model.translation
        
        inLexickonStateView.configure(input: .init(state: .hasAsNewWord))
        
        let contentOffsetX = scrollView.rx
            .didScroll
            .asDriver()
            .map { [unowned self] _ in self.scrollView.contentOffset.x }
            .filter { $0 >= 0 }
        
        let isPullingUp = contentOffsetX
            .map { [unowned self] x -> Bool in
                let result = self.lastX > x
                self.lastX = x
                return result
            }
            .distinctUntilChanged()
            .asDriver()
        
        let swipeSelection = isPullingUp
            .filter { $0 }
        
        swipeSelection
            .drive(onNext: { [unowned self] _ in
                switch self.model.wordSelectionState {
                case .selected:
                    self.model.wordSelectionState = .notSelected
                case .notSelected, .none:
                    self.model.wordSelectionState = .selected
                }
            })
            .disposed(by: disposeBag)
        
        Driver.combineLatest(
            contentOffsetX,
            isPullingUp
        ) .flatMapLatest { x, isPullingUp -> Driver<CGFloat> in
            isPullingUp ? .empty() : .just(x)
        }
        .drive(onNext: { [unowned self] offsetX in
            
            let offset = offsetX * 0.5
            
            print("🎲 \(offset)")
        })
        .disposed(by: disposeBag)
        
        addWordButton.rx.tap
            .asSignal()
            .emit(to: model.addWordButtonDidTapRelay)
            .disposed(by: disposeBag)
    }
}

extension MainTranslationResultCell: ClassIdentifiable {}
extension MainTranslationResultCell: UIScrollViewDelegate {}

private extension Reactive where Base: MainTranslationResultCell {
    var selectionStateOffset: Binder<MainTranslationCellModel.SelectionState> {
        Binder(base) { base, state in
            base.model.wordSelectionState = state
            UIView.animate(withDuration: 0.2) {
                switch base.model.wordSelectionState {
                case .selected, .notSelected:
                    base.selectionIcon.alpha = 1
                case .none:
                    base.selectionIcon.alpha = 0
                }
                base.layoutIfNeeded()
            }
        }
    }
}
