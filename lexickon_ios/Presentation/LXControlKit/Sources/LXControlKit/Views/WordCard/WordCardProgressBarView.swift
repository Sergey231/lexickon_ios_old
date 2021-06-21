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
    
    private let levelView = UIView()
    
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
            let safeAreaTop = UIApplication.shared.windows[0].safeAreaInsets.top
            $0.height.equalTo(safeAreaTop + 48)
        }
        
    }
    
    public func configure(input: Input) -> Output {
        
        input.studyState
            .drive(rx.studyState)
            .disposed(by: disposeBag)
        
        return Output(didTapBack: backButton.rx.tap.asSignal())
    }
}

private extension Reactive where Base : WordCardProgressBarView {
    
}


