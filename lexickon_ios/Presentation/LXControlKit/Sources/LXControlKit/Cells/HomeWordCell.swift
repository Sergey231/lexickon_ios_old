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

public struct HomeWordViewModel {
    
    public init(
        word: String,
        studyType: StudyType,
        didSelect: @escaping () -> ()
    ) {
        self.word = word
        self.studyType = studyType
        self.didSelect = didSelect
    }
    
    public var isReady: Bool { self.studyType == .ready }
    
    public let word: String
    public let studyType: StudyType
    public let didSelect: () -> ()
}

extension HomeWordViewModel: Hashable {
    public static func == (lsh: Self, rsh: Self) -> Bool {
        return lsh.word == rsh.word
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
    
    private enum SelectionType {
        case selected
        case notSelected
        case none
    }
    
    private let scrollView = UIScrollView()
    private let swipeContentView = UIView()
    private let wordLable = UILabel()
    private let progressView = WideWordProgressView()
    private lazy var iconImageView = UIImageView()
    private let selectionIcon = SwitchIconButton()
    private lazy var logo = Logo()
    
    private var wordSelectedState = BehaviorRelay<SelectionType>(value: .none)
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
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.size.equalTo(18)
            }
        }
        
        progressView.setup {
            $0.layer.cornerRadius = CornerRadius.big
            contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
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
        
        contentOffsetX
            .withLatestFrom(wordSelectedState.asDriver()) { (offsetX: $0, wordSelectedState: $1) }
            .drive(onNext: { [unowned self] args in
                let rightMargin = args.wordSelectedState == .none
                    ? Margin.regular
                    : Margin.big
                let offset = -(rightMargin + (args.offsetX * 0.5))
                progressView.snp.updateConstraints {
                    $0.right.equalToSuperview().offset(offset)
                }
        })
        .disposed(by: disposeBag)
        
        let selection = contentOffsetX
            .map { [unowned self] x -> Bool in
                let result = self.lastX > x
                self.lastX = x
                return result
            }
            .distinctUntilChanged()
            .filter { $0 }
            .do(onNext: { _ in
                model.didSelect()
            })
            
        selection
            .withLatestFrom(wordSelectedState.asDriver())
            .map { state in
                switch state {
                case .selected:
                    return .notSelected
                case .notSelected, .none:
                    return .selected
                }
            }
            .drive(wordSelectedState)
            .disposed(by: disposeBag)
        
        var selectionOnColor: UIColor = Colors.fireWordBright.color
        
        switch model.studyType {
            
        case .fire:
            wordLable.textColor = Colors.fireWordBright.color
            iconImageView.image = Images.wordMustReapetIcon.image
            iconImageView.tintColor = Colors.fireWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.fireWordPale.color,
                    progressColor: Colors.fireWord.color,
                    progress: 0.5
                )
            )
            selectionOnColor = Colors.fireWordBright.color
        case .ready:
            wordLable.textColor = Colors.readyWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.readyWordPale.color,
                    progressColor: Colors.readyWord.color,
                    progress: 0.5
                )
            )
            selectionOnColor = Colors.readyWordBright.color
        case .new:
            wordLable.textColor = Colors.newWordBright.color
            iconImageView.image = Images.newWordIcon.image
            iconImageView.tintColor = Colors.newWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.newWord.color,
                    progressColor: Colors.newWord.color,
                    progress: 0.5
                )
            )
            selectionOnColor = Colors.newWordBright.color
        case .waiting:
            wordLable.textColor = Colors.waitingWordBright.color
            iconImageView.image = Images.waitingWordIcon.image
            iconImageView.tintColor = Colors.waitingWordBright.color
            progressView.configure(
                input: WideWordProgressView.Input(
                    bgColor: Colors.waitingWordPale.color,
                    progressColor: Colors.waitingWord.color,
                    progress: 0.5
                )
            )
            selectionOnColor = Colors.waitingWordBright.color
        }
        
        wordSelectedState
            .asDriver()
            .drive(onNext: { [unowned self] state in
                UIView.animate(withDuration: 0.3) {
                    switch state {
                    case .selected, .notSelected:
                        self.progressView.snp.updateConstraints {
                            $0.right.equalTo(-Margin.big)
                        }
                    case .none:
                        self.progressView.snp.updateConstraints {
                            $0.right.equalToSuperview().offset(-Margin.regular)
                        }
                    }
                    self.progressView.superview?.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        let isWordSelected = wordSelectedState
            .asDriver()
            .map { state -> Bool in
                switch state {
                case .selected:
                    return true
                case .notSelected, .none:
                    return false
                }
            }
        
        selectionIcon.configure(
            input: SwitchIconButton.Input(
                onIcon: Images.Selection.on.image,
                offIcon: Images.Selection.off.image,
                onColor: selectionOnColor,
                offColor: Colors.paleText.color,
                selected: isWordSelected
            )
        )
    }
}

extension HomeWordCell: ClassIdentifiable {}
