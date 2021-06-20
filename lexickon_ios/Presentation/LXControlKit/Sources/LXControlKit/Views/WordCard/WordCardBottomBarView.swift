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
    
    fileprivate struct UIConstants {
        static let addButtonSize: CGFloat = 56
    }
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(wordRaiting: Driver<CGFloat>) {
            self.wordRaiting = wordRaiting
        }
        let wordRaiting: Driver<CGFloat>
    }
    
    public struct Output {
        public let didTapSpeekerButton: Signal<Void>
        public let didTapWordRaitingButton: Signal<Void>
        public let didTapAddWordButton: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let speekButtonImageView = SpeekerButton()
    fileprivate let addWordButton = AddWordButton()
    fileprivate let wordRaitingView = WordRatingView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        snp.makeConstraints {
            $0.height.equalTo(56)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        speekButtonImageView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(46)
            }
        }
        
        addWordButton.setup {
            $0.setShadow()
            addSubview($0)
            $0.snp.makeConstraints {
                $0.right.equalToSuperview().offset(-Margin.big)
                $0.centerY.equalTo(speekButtonImageView.snp.centerY)
                $0.size.equalTo(UIConstants.addButtonSize)
            }
        }
        
        wordRaitingView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(speekButtonImageView.snp.centerY)
                $0.size.equalTo(64)
                $0.left.equalToSuperview().offset(Margin.big)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        let wordRaitingOutput = wordRaitingView.configure(
            input: WordRatingView.Input(
                rating: input.wordRaiting
            )
        )
        
        let speekerButtonOutput = speekButtonImageView.configure()
        
        return Output(
            didTapSpeekerButton: speekerButtonOutput.didTap,
            didTapWordRaitingButton: wordRaitingOutput.didTap,
            didTapAddWordButton: addWordButton.rx.tap.asSignal()
        )
    }
}

private extension Reactive where Base : WordCardTopBarView {
   
}


