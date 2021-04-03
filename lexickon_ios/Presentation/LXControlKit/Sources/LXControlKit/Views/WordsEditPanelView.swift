//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 30.03.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets

public final class WordEditPanelView: UIView {
    
    fileprivate enum UIConstants {
        static let plateViewHeight: CGFloat = 44
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    public struct Input {
        public init(
            learnCount: Driver<UInt>,
            resetCount: Driver<UInt>,
            deleteCount: Driver<UInt>
        ) {
            self.learnCount = learnCount
            self.resetCount = resetCount
            self.deleteCount = deleteCount
        }
        let learnCount: Driver<UInt>
        let resetCount: Driver<UInt>
        let deleteCount: Driver<UInt>
    }
    
    public struct Output {
        public let height: Driver<CGFloat>
    }
    
    private let disposeBag = DisposeBag()
    
    fileprivate let learnWordsView = PlateView()
    fileprivate let resetWordsView = PlateView()
    fileprivate let deleteWordsView = PlateView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    // MARK: Create UI
    
    private func createUI(input: Input) {
        
        backgroundColor = .clear
        
        deleteWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                $0.height.equalTo(UIConstants.plateViewHeight)
            }
        }
        
        resetWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalTo(deleteWordsView.snp.top).offset(-Margin.regular)
                $0.height.equalTo(0)
            }
        }
        
        learnWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalTo(resetWordsView.snp.top).offset(-Margin.regular)
                $0.height.equalTo(0)
            }
        }
    }
    
    // MAEK: Configure
    
    public func configure(input: Input) -> Output {
        
        createUI(input: input)
        
        input.deleteCount
            .drive(rx.deleteWordsViewCount)
            .disposed(by: disposeBag)
        
        input.resetCount
            .drive(rx.resetWordsViewCount)
            .disposed(by: disposeBag)
        
        input.learnCount
            .drive(rx.learnWordsViewCount)
            .disposed(by: disposeBag)
        
        let resetWordsTitle = input.learnCount
            .map { Str.wordsEditPanelResetTitle($0) }
        
        let learnWordsTitle = input.learnCount
            .map { Str.wordsEditPanelLearnTitle($0) }
        
        let deleteWordsTitle = input.deleteCount
            .map { Str.wordsEditPanelDeleteTitle($0) }
        
        let resetWordsViewOutput = resetWordsView.configure(
            input: PlateView.Input(
                title: resetWordsTitle
            )
        )
        
        let learnWordsViewOutput = learnWordsView.configure(
            input: PlateView.Input(
                title: learnWordsTitle
            )
        )
        
        let deleteWordsViewOutput = deleteWordsView.configure(
            input: PlateView.Input(
                title: deleteWordsTitle,
                titleColor: .red
            )
        )
        
        resetWordsViewOutput.didTap.debug("👀").emit()
        learnWordsViewOutput.didTap.debug("⌨️").emit()
        deleteWordsViewOutput.didTap.debug("⚽️").emit()
        
        return Output(height: Driver.just(200))
    }
}

extension Reactive where Base: WordEditPanelView {
    
    var deleteWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.plateViewHeight
                : 0
            UIView.animate(withDuration: 0.3) {
                base.deleteWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                base.layoutIfNeeded()
            }
        }
    }
    
    var resetWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.plateViewHeight
                : 0
            UIView.animate(withDuration: 0.3) {
                base.resetWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
            }
        }
    }
    
    var learnWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.plateViewHeight
                : 0
            UIView.animate(withDuration: 0.3) {
                base.learnWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
            }
        }
    }
}
