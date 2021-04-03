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
    
    private let learnWordsView = PlateView()
    private let resetWordsView = PlateView()
    fileprivate let deleteWordsView = PlateView()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI(input: Input) {
        
        backgroundColor = .clear
        
        deleteWordsView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
                $0.height.equalTo(44)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        createUI(input: input)
        
        input.deleteCount
            .drive(rx.deleteWordsViewCount)
            .disposed(by: disposeBag)
        
        return Output(height: Driver.just(100))
    }
}

extension Reactive where Base: WordEditPanelView {
    
    var deleteWordsViewCount: Binder<UInt> {
        Binder(base) { base, count in
            let height = count > 0 ? 44 : 0
            UIView.animate(withDuration: 0.3) {
                base.deleteWordsView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                base.layoutIfNeeded()
            }
        }
    }
}
