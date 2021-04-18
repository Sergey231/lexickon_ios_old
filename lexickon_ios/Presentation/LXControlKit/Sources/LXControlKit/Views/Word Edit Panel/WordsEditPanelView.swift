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
        static let itemHeight: CGFloat = 44
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    public struct Input {
        public init(
            learnCount: Driver<UInt>,
            resetCount: Driver<UInt>,
            deleteCount: Driver<UInt>,
            addingCount: Driver<UInt>
        ) {
            self.learnCount = learnCount
            self.resetCount = resetCount
            self.deleteCount = deleteCount
            self.addingCount = addingCount
        }
        let learnCount: Driver<UInt>
        let resetCount: Driver<UInt>
        let deleteCount: Driver<UInt>
        let addingCount: Driver<UInt>
    }
    
    public struct Output {
        public let height: Driver<CGFloat>
    }
    
    private let disposeBag = DisposeBag()
    
    fileprivate let learnWordsView = SubmenuItem()
    fileprivate let resetWordsView = SubmenuItem()
    fileprivate let deleteWordsView = SubmenuItem()
    fileprivate let addingWordsView = SubmenuItem()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    // MARK: Create UI
    
    private func createUI(input: Input) {
        
        setShadow()
        backgroundColor = .white
        layer.cornerRadius = CornerRadius.big
        
        deleteWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                $0.height.equalTo(UIConstants.itemHeight)
            }
        }
        
        addingWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalTo(deleteWordsView.snp.top).offset(-Margin.regular)
                $0.height.equalTo(0)
            }
        }
        
        resetWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalTo(addingWordsView.snp.top).offset(-Margin.regular)
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
        
        input.addingCount
            .drive(rx.addingWordsViewCount)
            .disposed(by: disposeBag)
        
        input.resetCount
            .drive(rx.resetWordsViewCount)
            .disposed(by: disposeBag)
        
        input.learnCount
            .drive(rx.learnWordsViewCount)
            .disposed(by: disposeBag)
        
        let resetWordsTitle = input.resetCount
            .map { Str.wordsEditPanelResetTitle($0) }
        
        let learnWordsTitle = input.learnCount
            .map { Str.wordsEditPanelLearnTitle($0) }
        
        let deleteWordsTitle = input.deleteCount
            .map { Str.wordsEditPanelDeleteTitle($0) }
        
        let addingWordsTitle = input.addingCount
            .map { "Добавить в Lexickon (\($0))" }
        
        let resetWordsViewOutput = resetWordsView.configure(
            input: SubmenuItem.Input(
                title: resetWordsTitle,
                emojiIcon: .just("🧹")
            )
        )
        
        let learnWordsViewOutput = learnWordsView.configure(
            input: SubmenuItem.Input(
                title: learnWordsTitle,
                emojiIcon: .just("🚀")
            )
        )
        
        let addingWordsViewOutput = addingWordsView.configure(
            input: SubmenuItem.Input(
                title: addingWordsTitle,
                emojiIcon: .just("📥")
            )
        )
        
        let deleteWordsViewOutput = deleteWordsView.configure(
            input: SubmenuItem.Input(
                title: deleteWordsTitle,
                emojiIcon: .just("🔥"),
                titleColor: .red
            )
        )
        
//        resetWordsViewOutput.didTap.debug("👀").emit()
//        learnWordsViewOutput.didTap.debug("⌨️").emit()
//        deleteWordsViewOutput.didTap.debug("⚽️").emit()
//        addingWordsViewOutput.didTap.debug("⚽️").emit()
        
        return Output(height: .just(280))
    }
}

// Rx Extension

extension Reactive where Base: WordEditPanelView {
    
    var deleteWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            UIView.animate(withDuration: 0.3) {
                base.deleteWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                base.layoutIfNeeded()
            }
        }
    }
    
    var addingWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            let bottomMargin = count > 0
                ? -Margin.regular
                : 0
            UIView.animate(withDuration: 0.3) {
                base.addingWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.bottom.equalTo(base.deleteWordsView.snp.top).offset(bottomMargin)
                }
                base.layoutIfNeeded()
            }
        }
    }
    
    var resetWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            let bottomMargin = count > 0
                ? -Margin.regular
                : 0
            UIView.animate(withDuration: 0.3) {
                base.resetWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.bottom.equalTo(base.addingWordsView.snp.top).offset(bottomMargin)
                }
            }
        }
    }
    
    var learnWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            let bottomMargin = count > 0
                ? -Margin.regular
                : 0
            UIView.animate(withDuration: 0.3) {
                base.learnWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.bottom.equalTo(base.resetWordsView.snp.top).offset(bottomMargin)
                }
            }
        }
    }
}
