//
//  HomeWordCell.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 03.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Utils
import RxDataSources
import RxExtensions
import UIExtensions
import Assets
import LexickonApi
import LexickonStateEntity

// MARK: Cell Model

public class HomeWordCellModel {
    
    public enum SelectionState {
        case selected
        case notSelected
        case none
    }
    
    public var disposeBag = DisposeBag()
    
    public var isReady: Bool { self.studyState == .ready }
    public let word: String
    public let wordEntity: WordEntity
    public let isEditMode: Driver<Bool>
    public let studyState: LxStudyState
    public let updateWordStudyProgresEvent: Signal<Void>
    public var tapWithoutEditMode: Signal<Void> {
        self.tapWithoutEditModeRelay.asSignal()
    }
    
    fileprivate var wordSelectionStateChangedRelay = PublishRelay<Void>()
    fileprivate let tapWithoutEditModeRelay = PublishRelay<Void>()
    public var wordSelectionState: SelectionState = .none
    
    public var wordSelectionStateDriver: Driver<HomeWordCellModel> {
        wordSelectionStateChangedRelay
            .asDriver(onErrorDriveWith: .empty())
            .map { _ in self }
    }
    
    public init(
        wordEntity: WordEntity,
        isEditMode: Driver<Bool>,
        updateWordStudyProgresEvent: Signal<Void>
    ) {
        self.wordEntity = wordEntity
        self.word = wordEntity.studyWord
        self.studyState = wordEntity.studyState
        self.isEditMode = isEditMode
        self.updateWordStudyProgresEvent = updateWordStudyProgresEvent
    }
}

extension HomeWordCellModel: Hashable {
    public static func == (
        lsh: HomeWordCellModel,
        rsh: HomeWordCellModel
    ) -> Bool {
        lsh.word == rsh.word
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

extension HomeWordCellModel: IdentifiableType {
    public var identity: String {
        return self.word
    }
    public typealias Identity = String
}

// MARK: Table View Cell

public final class HomeWordCell: DisposableTableViewCell, UIScrollViewDelegate {
    
    fileprivate var model: HomeWordCellModel!
    
    private let scrollView = UIScrollView()
    private let swipeContentView = UIView()
    fileprivate let selectionIcon = CheckBox()
    
    fileprivate let progressView = WideWordProgressView()
    private let wordLable = UILabel()
    private lazy var iconImageView = UIImageView()
    private lazy var logo = Logo()
    
    private var lastX: CGFloat = 0
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: Create UI
    
    private func createUI(with input: HomeWordCellModel) {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        
        selectionIcon.setup {
            contentView.addSubview($0)
            $0.snp.remakeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalTo(18)
                $0.width.equalTo(46)
            }
        }
        
        progressView.setup {
            $0.layer.cornerRadius = CornerRadius.big
            contentView.addSubview($0)
            $0.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalTo(selectionIcon.snp.left)
                $0.top.equalToSuperview().offset(Margin.regular/2)
                $0.bottom.equalToSuperview().offset(-Margin.regular/2)
            }
        }
        
        if input.isReady {
            progressView.addSubview(logo)
            logo.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(45)
                $0.centerY.equalToSuperview()
            }

        } else {
            progressView.addSubview(iconImageView)
            iconImageView.snp.remakeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(45)
                $0.centerY.equalToSuperview()
            }
        }
        
        wordLable.setup {
            $0.font = .regular24
            contentView.addSubview($0)

            if input.isReady {
                wordLable.snp.remakeConstraints {
                    $0.left.equalTo(logo.snp.right).offset(Margin.small)
                    $0.right.equalToSuperview().offset(-Margin.regular)
                    $0.centerY.equalToSuperview()
                }
            } else {
                wordLable.snp.remakeConstraints {
                    $0.left.equalTo(iconImageView.snp.right).offset(Margin.small)
                    $0.right.equalToSuperview().offset(-Margin.regular)
                    $0.centerY.equalToSuperview()
                }
            }
        }
        
        scrollView.setup {
            $0.delegate = self
            $0.alwaysBounceHorizontal = true
            contentView.addSubview($0)
            $0.snp.remakeConstraints {
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
    
    // MARK: Configure UI
    
    public func configurate(with model: HomeWordCellModel) {
        
        self.model = model
        createUI(with: model)
        
        logo.configure(with: .init(tintColor: Colors.readyWordBright.color))
        
        wordLable.text = model.word
        
        let tap = UITapGestureRecognizer()
        scrollView.addGestureRecognizer(tap)
        
        let tappedInEditMode: Signal<Void> = tap.rx.event
            .withLatestFrom(model.isEditMode) { $1 }
            .filter { $0 }
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
        
        tap.rx.event
            .withLatestFrom(model.isEditMode) { $1 }
            .filter(!)
            .map { _ in () }
            .asSignal(onErrorSignalWith: .empty())
            .emit(to: model.tapWithoutEditModeRelay)
            .disposed(by: disposeBag)

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
            .map { _ in () }
        
        Driver.combineLatest(
            contentOffsetX,
            isPullingUp
        ) .flatMapLatest { x, isPullingUp -> Driver<CGFloat> in
            isPullingUp ? .empty() : .just(x)
        }
        .drive(onNext: { [unowned self] offsetX in
            
            let selectionIconWidth = self.model.wordSelectionState == .none
                ? Margin.regular
                : 46
            
            let offset = (selectionIconWidth + (offsetX * 0.5))
            
            selectionIcon.snp.updateConstraints {
                $0.width.equalTo(offset)
            }
        })
        .disposed(by: disposeBag)
            
        let anySelection = Driver.merge(
            swipeSelection,
            tappedInEditMode.asDriver(onErrorDriveWith: .empty())
        )
        
        anySelection
            .drive(onNext: { [unowned self] _ in
                switch self.model.wordSelectionState {
                case .selected:
                    self.model.wordSelectionState = .notSelected
                case .notSelected, .none:
                    self.model.wordSelectionState = .selected
                }
            })
            .disposed(by: disposeBag)
        
        var wordColor: UIColor = Colors.fireWordBright.color
        var progressColor: UIColor = Colors.fireWord.color
        var bgColor: UIColor = Colors.fireWordPale.color
        
        switch model.studyState {
            
        case .fire, .downgradeRating:
            iconImageView.image = Images.wordMustReapetIcon.image
            wordColor = Colors.fireWordBright.color
            progressColor = Colors.fireWord.color
            bgColor = Colors.fireWordPale.color

        case .ready:
            iconImageView.image = Images.newWordIcon.image
            wordColor = Colors.readyWordBright.color
            progressColor = Colors.readyWord.color
            bgColor = Colors.readyWordPale.color
            
        case .new:
            iconImageView.image = Images.newWordIcon.image
            wordColor = Colors.newWordBright.color
            progressColor = Colors.newWord.color
            bgColor = Colors.newWord.color
            
        case .waiting:
            iconImageView.image = Images.waitingWordIcon.image
            wordColor = Colors.waitingWordBright.color
            progressColor = Colors.waitingWord.color
            bgColor = Colors.waitingWordPale.color
        }
        
        let progress = model.updateWordStudyProgresEvent
            .map { CGFloat(model.wordEntity.studyStatePercent) }
            .asDriver(onErrorJustReturn: 0)
            .startWith(CGFloat(model.wordEntity.studyStatePercent))
        
        wordLable.textColor = wordColor
        iconImageView.tintColor = wordColor
        progressView.configure(
            input: WideWordProgressView.Input(
                bgColor: bgColor,
                progressColor: progressColor,
                progress: progress
            )
        )
        
        anySelection
            .asSignal(onErrorSignalWith: .empty())
            .map { _ in () }
            .emit(to: model.wordSelectionStateChangedRelay)
            .disposed(by: disposeBag)
        
        anySelection
            .map { [unowned self] _ in self.model.wordSelectionState }
            .asDriver()
            .drive(rx.selectionStateOffset)
            .disposed(by: disposeBag)
        
        let stateAferEditModeChanging = model.isEditMode
            .debounce(.microseconds(10))
            .map { [unowned self] isEditMode -> HomeWordCellModel.SelectionState in
                switch (isEditMode, self.model.wordSelectionState) {
                case (true, .none): return .notSelected
                case (true, .selected): return .selected
                case (true, .notSelected): return .notSelected
                case (false, _): return .none
                }
            }
            
        stateAferEditModeChanging
            .drive(rx.selectionStateOffset)
            .disposed(by: disposeBag)
        
        let isWordSelected = stateAferEditModeChanging
            .map { [unowned self] _ -> Bool in
                switch self.model.wordSelectionState {
                case .selected:
                    return true
                case .notSelected, .none:
                    return false
                }
            }
            .startWith(false)
        
        selectionIcon.configure(
            input: CheckBox.Input(
                onIcon: Images.Selection.on.image,
                offIcon: Images.Selection.off.image,
                onColor: wordColor,
                offColor: Colors.paleText.color,
                selected: isWordSelected,
                animated: false
            )
        )
    }
}

extension HomeWordCell: ClassIdentifiable {}

// MARK: Rx Extensions

private extension Reactive where Base: HomeWordCell {
    var selectionStateOffset: Binder<HomeWordCellModel.SelectionState> {
        Binder(base) { base, state in
            base.model.wordSelectionState = state
            UIView.animate(withDuration: 0.2) {
                switch base.model.wordSelectionState {
                case .selected, .notSelected:
                    base.selectionIcon.alpha = 1
                    base.selectionIcon.snp.updateConstraints {
                        $0.width.equalTo(46)
                    }
                case .none:
                    base.selectionIcon.alpha = 0
                    base.selectionIcon.snp.updateConstraints {
                        $0.width.equalTo(Margin.regular)
                    }
                }
                base.progressView.superview?.layoutIfNeeded()
            }
        }
    }
}
