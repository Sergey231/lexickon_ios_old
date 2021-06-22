//
//  WordCardProgressBarView.swift
//  
//
//  Created by Sergey Borovikov on 21.06.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets
import LexickonApi

public final class WordCardProgressBarView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    private enum UIConstrant {
        static let wordLevelViewSize: CGFloat = 48
    }
    
    public struct Input {
        public init(
            studyState: Driver<StudyType>,
            waitingTimePeriod: Driver<Int>,
            readyTimePeriod: Driver<Int>,
            fireTimePariod: Driver<Int>
        ) {
            self.studyState = studyState
            self.waitingTimePeriod = waitingTimePeriod
            self.readyTimePeriod = readyTimePeriod
            self.fireTimePariod = fireTimePariod
        }
        let studyState: Driver<StudyType>
        let waitingTimePeriod: Driver<Int>
        let readyTimePeriod: Driver<Int>
        let fireTimePariod: Driver<Int>
    }
    
    public struct Output {
        public let didTapBack: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    fileprivate let levelView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        levelView.setup {
            $0.layer.cornerRadius = UIConstrant.wordLevelViewSize/2
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(4)
                $0.top.equalTo(4)
                $0.size.equalTo(UIConstrant.wordLevelViewSize)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        input.studyState
            .drive(rx.studyState)
            .disposed(by: disposeBag)
        
        return Output(didTapBack: .empty())
    }
}

private extension Reactive where Base : WordCardProgressBarView {
    var studyState: Binder<StudyType> {
        Binder(base) { base, stdudyState in
            switch stdudyState {
            
            case .fire:
                base.levelView.backgroundColor = Colors.fireWordBright.color
            case .ready:
                base.levelView.backgroundColor = Colors.readyWordBright.color
            case .new:
                base.levelView.backgroundColor = Colors.newWordBright.color
            case .waiting:
                base.levelView.backgroundColor = Colors.waitingWordBright.color
            }
        }
    }
}
