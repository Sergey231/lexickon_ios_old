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
        public let addWordsDidTap: Signal<Void>
        public let learnWordsDidTap: Signal<Void>
        public let resetWordsDidTap: Signal<Void>
        public let deleteWordsDidTap: Signal<Void>
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
        
        addingWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalToSuperview().offset(0)
                $0.height.equalTo(0)
            }
        }
        
        learnWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(addingWordsView.snp.bottom).offset(0)
                $0.height.equalTo(0)
            }
        }
        
        resetWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(learnWordsView.snp.bottom).offset(0)
                $0.height.equalTo(0)
            }
        }
        
        deleteWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(resetWordsView.snp.bottom).offset(0)
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
        
        let height: Driver<CGFloat> = Driver.combineLatest(
            input.addingCount,
            input.deleteCount,
            input.learnCount,
            input.resetCount
        ) { addingCount, deleteCount, learnCount, resetCount -> Int in
            let itemsCount = (addingCount == 0 ? 0 : 1)
                + (deleteCount == 0 ? 0 : 1)
                + (learnCount == 0 ? 0 : 1)
                + (resetCount == 0 ? 0 : 1)
            return itemsCount
        }
        .map { itemsCount -> CGFloat in
            let itemHeight = (WordEditPanelView.UIConstants.itemHeight + Margin.regular)
            let window = UIApplication.shared.windows[0]
            let bottomPadding = window.safeAreaInsets.bottom
            return CGFloat(itemsCount) * itemHeight + bottomPadding
        }
        
        return Output(
            addWordsDidTap: addingWordsViewOutput.didTap,
            learnWordsDidTap: learnWordsViewOutput.didTap,
            resetWordsDidTap: resetWordsViewOutput.didTap,
            deleteWordsDidTap: deleteWordsViewOutput.didTap,
            height: height
        )
    }
}

// Rx Extension

extension Reactive where Base: WordEditPanelView {
    
    var addingWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            let topMargin = count > 0
                ? Margin.regular
                : 0
            UIView.animate(withDuration: 0.3) {
                base.addingWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.top.equalToSuperview().offset(topMargin)
                }
                base.layoutIfNeeded()
            }
        }
    }
    
    var learnWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            let topMargin = count > 0
                ? Margin.regular
                : 0
            UIView.animate(withDuration: 0.3) {
                base.learnWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.top.equalTo(base.addingWordsView.snp.bottom).offset(topMargin)
                }
            }
        }
    }
    
    var resetWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            let topMargin = count > 0
                ? Margin.regular
                : 0
            UIView.animate(withDuration: 0.3) {
                base.resetWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.top.equalTo(base.learnWordsView.snp.bottom).offset(topMargin)
                }
            }
        }
    }
    
    var deleteWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0
                ? WordEditPanelView.UIConstants.itemHeight
                : 0
            let topMargin = count > 0
                ? Margin.regular
                : 0
            UIView.animate(withDuration: 0.3) {
                base.deleteWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                    $0.top.equalTo(base.resetWordsView.snp.bottom).offset(topMargin)
                }
                base.layoutIfNeeded()
            }
        }
    }
}
