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

public class HomeWordViewModel {
    
    public enum SelectionType {
        case selected
        case notSelected
        case none
    }
    
    public var disposeBag = DisposeBag()
    
    public var isReady: Bool { self.studyType == .ready }
    public let word: String
    public let studyType: StudyType
    public let didTap: PublishRelay<Void>
    
    fileprivate var wordSelectedStateRelay = BehaviorRelay<SelectionType>(value: .none)
    public var wordSelectedState: SelectionType = .none
    
    public init(
        word: String,
        studyType: StudyType,
        didTap: PublishRelay<Void>
    ) {
        self.word = word
        self.studyType = studyType
        self.didTap = didTap
        
        self.configureWordSeletedState()
    }
    
    private func configureWordSeletedState() {
        wordSelectedStateRelay
            .asDriver()
            .drive(onNext: { [unowned self] state in
//                print("😀😀 \(Unmanaged.passUnretained(self).toOpaque())")
                self.wordSelectedState = state
            })
            .disposed(by: disposeBag)
    }
}

extension HomeWordViewModel: Hashable {
    public static func == (
        lsh: HomeWordViewModel,
        rsh: HomeWordViewModel
    ) -> Bool {
        lsh.word == rsh.word
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
}

extension HomeWordViewModel: IdentifiableType {
    public var identity: String {
        return self.word
    }
    public typealias Identity = String
}

public final class HomeWordCell: DisposableTableViewCell, UIScrollViewDelegate {
    
    private let scrollView = UIScrollView()
    private let swipeContentView = UIView()
    private let wordLable = UILabel()
    private let progressView = WideWordProgressView()
    private lazy var iconImageView = UIImageView()
    private let selectionIcon = CheckBox()
    private lazy var logo = Logo()
    
    private var lastX: CGFloat = 0
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI(with input: HomeWordViewModel) {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true
        
        selectionIcon.setup {
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview()
                $0.height.equalTo(18)
                $0.width.equalTo(46)
            }
        }
        
        progressView.setup {
            $0.layer.cornerRadius = CornerRadius.big
            contentView.addSubview($0)
            $0.snp.makeConstraints {
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
            iconImageView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.size.equalTo(45)
                $0.centerY.equalToSuperview()
            }
        }
        
        wordLable.setup {
            $0.font = .systemRegular24
            contentView.addSubview($0)

            if input.isReady {
                wordLable.snp.makeConstraints {
                    $0.left.equalTo(logo.snp.right).offset(Margin.small)
                    $0.right.equalToSuperview().offset(-Margin.regular)
                    $0.centerY.equalToSuperview()
                }
            } else {
                wordLable.snp.makeConstraints {
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
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        swipeContentView.setup {
            scrollView.addSubview($0)
            $0.snp.makeConstraints { [unowned self] in
                $0.height.greaterThanOrEqualTo(self.contentView.snp.height)
                $0.width.greaterThanOrEqualTo(self.contentView.snp.width)
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configurate(with model: HomeWordViewModel) {
        
        createUI(with: model)
        
        logo.configure(with: .init(tintColor: Colors.readyWordBright.color))
        
        wordLable.text = model.word
        
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
            
        let selection = isPullingUp
            .filter { $0 }
            .do(onNext: { _ in model.didTap.accept(()) })
        
        Driver.combineLatest(
            contentOffsetX,
            isPullingUp
        ) .flatMapLatest { x, isPullingUp -> Driver<CGFloat> in
            isPullingUp ? .empty() : .just(x)
        }
        .withLatestFrom(
            model.wordSelectedStateRelay.asDriver()
        ) { (offsetX: $0, wordSelectedState: $1) }
        .drive(onNext: { [unowned self] args in
            
            let selectionIconWidth = args.wordSelectedState == .none
                ? Margin.regular
                : 46
            
            let offset = (selectionIconWidth + (args.offsetX * 0.5))
            
            selectionIcon.snp.updateConstraints {
                $0.width.equalTo(offset)
            }
        })
        .disposed(by: disposeBag)
            
        selection
            .withLatestFrom(model.wordSelectedStateRelay.asDriver())
            .map { state in
                switch state {
                case .selected:
                    return .notSelected
                case .notSelected, .none:
                    return .selected
                }
            }
            .drive(model.wordSelectedStateRelay)
            .disposed(by: disposeBag)
        
        var wordColor: UIColor = Colors.fireWordBright.color
        var progressColor: UIColor = Colors.fireWord.color
        var bgColor: UIColor = Colors.fireWordPale.color
        
        switch model.studyType {
            
        case .fire:
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
        
        wordLable.textColor = wordColor
        iconImageView.tintColor = wordColor
        progressView.configure(
            input: WideWordProgressView.Input(
                bgColor: bgColor,
                progressColor: progressColor,
                progress: 0.5
            )
        )
        
        model.wordSelectedStateRelay
            .asDriver()
            .drive(onNext: { [unowned self] state in
                UIView.animate(withDuration: 0.2) {
                    switch state {
                    case .selected, .notSelected:
                        selectionIcon.alpha = 1
                        self.selectionIcon.snp.updateConstraints {
                            $0.width.equalTo(46)
                        }
                    case .none:
                        selectionIcon.alpha = 0
                        self.selectionIcon.snp.updateConstraints {
                            $0.width.equalTo(Margin.regular)
                        }
                    }
                    self.progressView.superview?.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        let isWordSelected = model.wordSelectedStateRelay
            .asDriver()
            .map { state -> Bool in
                switch state {
                case .selected:
                    return true
                case .notSelected, .none:
                    return false
                }
            }
        
        if model.word == "Cup" {
            model.wordSelectedStateRelay.asDriver().debug("😀").drive()
        }
        
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
