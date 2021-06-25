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
    
    private enum UIConstants {
        static let wordLevelViewSize: CGFloat = 48
        static let wordLevelBgViewSize: CGFloat = 56
    }
    
    public struct Input {
        public init(
            studyState: Driver<StudyType>,
            wordLevel: Driver<Int>,
            waitingTimePeriod: Driver<Int>,
            readyTimePeriod: Driver<Int>,
            fireTimePariod: Driver<Int>
        ) {
            self.studyState = studyState
            self.wordLevel = wordLevel
            self.waitingTimePeriod = waitingTimePeriod
            self.readyTimePeriod = readyTimePeriod
            self.fireTimePariod = fireTimePariod
        }
        let studyState: Driver<StudyType>
        let wordLevel: Driver<Int>
        let waitingTimePeriod: Driver<Int>
        let readyTimePeriod: Driver<Int>
        let fireTimePariod: Driver<Int>
    }
    
    public struct Output {
        public let didTapBack: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    fileprivate let levelBgView = UIView()
    fileprivate let scaleBgView = UIView()
    fileprivate let scaleView = UIView()
    fileprivate let levelView = UIView()
    fileprivate let levelCountLabel = UILabel()
    fileprivate let levelTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        levelBgView.setup {
            $0.layer.cornerRadius = UIConstants.wordLevelBgViewSize/2
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview()
                $0.top.equalToSuperview()
                $0.size.equalTo(UIConstants.wordLevelBgViewSize)
            }
        }
        
        scaleBgView.setup {
            $0.layer.cornerRadius = 6
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(levelBgView.snp.centerY)
                $0.height.equalTo(22)
                $0.right.equalToSuperview()
                $0.left.equalToSuperview().offset(Margin.regular)
            }
        }
        
        levelView.setup {
            $0.layer.cornerRadius = UIConstants.wordLevelViewSize/2
            addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalTo(levelBgView.snp.center)
                $0.size.equalTo(UIConstants.wordLevelViewSize)
            }
        }
        
        scaleView.setup {
            $0.layer.cornerRadius = 4
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(levelView.snp.centerY)
                $0.height.equalTo(14)
                $0.width.equalTo(4)
                $0.left.equalTo(levelView.snp.right).offset(-4)
            }
        }
        
        levelCountLabel.setup {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .bold18
            levelView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview().offset(6)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(22)
            }
        }
        
        levelTitleLabel.setup {
            $0.textColor = .white
            $0.textAlignment = .center
            $0.font = .bold10
            $0.text = "Lvl."
            levelView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(levelCountLabel.snp.bottom)
                $0.left.right.equalToSuperview()
                $0.height.equalTo(12)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        input.studyState
            .drive(rx.studyState)
            .disposed(by: disposeBag)
        
        input.wordLevel
            .map { String($0) }
            .drive(levelCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        parentViewController?.rx.viewDidAppear
            .asSignal()
            .map { _ in CGFloat(1) }
            .emit(to: rx.progress)
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
                base.levelBgView.backgroundColor = Colors.fireWordPale.color
                base.scaleBgView.backgroundColor = Colors.fireWordPale.color
                base.scaleView.backgroundColor = Colors.fireWordBright.color
            case .ready:
                base.levelView.backgroundColor = Colors.readyWordBright.color
                base.levelBgView.backgroundColor = Colors.readyWordPale.color
                base.scaleBgView.backgroundColor = Colors.readyWordPale.color
                base.scaleView.backgroundColor = Colors.readyWordBright.color
            case .new:
                base.levelView.backgroundColor = Colors.newWordBright.color
                base.levelBgView.backgroundColor = Colors.newWord.color
                base.scaleBgView.backgroundColor = Colors.newWord.color
                base.scaleView.backgroundColor = Colors.newWordBright.color
            case .waiting:
                base.levelView.backgroundColor = Colors.waitingWordBright.color
                base.levelBgView.backgroundColor = Colors.waitingWordPale.color
                base.scaleBgView.backgroundColor = Colors.waitingWordPale.color
                base.scaleView.backgroundColor = Colors.waitingWordBright.color
            }
        }
    }
    
    var progress: Binder<CGFloat> {
        Binder(base) { base, progress in
            // test implementation
            UIView.animate(withDuration: 0.6) {
                base.scaleView.snp.updateConstraints {
                    $0.width.equalTo(4 + 260)
                }
                base.layoutIfNeeded()
            }
        }
    }
}
