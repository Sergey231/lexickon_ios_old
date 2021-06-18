//
//  WordCardBottomBarView.swift
//  
//
//  Created by Sergey Borovikov on 18.06.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets
import LexickonApi

public final class WordCardBottomBarView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(distributionStatus: Driver<CGFloat>) {
            self.distributionStatus = distributionStatus
        }
        let distributionStatus: Driver<CGFloat>
    }
    
    public struct Output {
        public let didTapBack: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let speekButton = UIButton()
    fileprivate let addWordButton = AddWordButton()
    fileprivate let wordDistributionIconView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        backgroundColor = .gray
        snp.makeConstraints {
            $0.height.equalTo(48)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        speekButton.setup {
            $0.textColor = .white
            addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(Size.icon)
            }
        }
        
        addWordButton.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-Margin.big)
                $0.centerY.equalTo(titleLabel.snp.centerY)
            }
        }
        
        wordDistributionIconView.setup {
            $0.backgroundColor = .red
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel.snp.centerY)
                $0.size.equalTo(56)
                $0.left.equalToSuperview().offset(Margin.big)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        input.studyState
            .drive(rx.studyState)
            .disposed(by: disposeBag)
        
        return Output(didTapBack: backButton.rx.tap.asSignal())
    }
}

private extension Reactive where Base : WordCardTopBarView {
    var studyState: Binder<StudyType> {
        Binder(base) { base, studyState in
            switch studyState {
            case .fire:
                base.titleLabel.text = Str.wordCardFireStateTitle
                base.backgroundColor = Colors.fireWordBG.color
            case .ready:
                base.titleLabel.text = Str.wordCardReadyStateTitle
                base.backgroundColor = Colors.mainBG.color
            case .new:
                base.titleLabel.text = Str.wordCardNewStateTitle
                base.backgroundColor = Colors.newWord.color
            case .waiting:
                base.titleLabel.text = Str.wordCardWaitingStateTitle
                base.backgroundColor = Colors.waitingWordBG.color
            }
        }
    }
}


