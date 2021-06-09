//
//  HomeHeaderView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 02.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets
import LexickonStateEntity

public final class HomeHeaderView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(
            isWordsUpdating: Driver<Bool>,
            lexickonState: Driver<LexickonStateEntity.State>
        ) {
            self.isWordsUpdating = isWordsUpdating
            self.lexickonState = lexickonState
        }
        let isWordsUpdating: Driver<Bool>
        let lexickonState: Driver<LexickonStateEntity.State>
    }
    
    public struct Output {
        let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    fileprivate let wordsStateButton = LexickonStateButton()
    fileprivate let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = Colors.mainBG.color
        
        wordsStateButton.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-24)
            }
        }
        
        infoLabel.setup {
            $0.text = Str.homeHeaderInfoDone
            $0.textAlignment = .center
            $0.textColor = .white
            addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalToSuperview()
                $0.height.equalTo(24)
                $0.bottom.equalTo(wordsStateButton.snp.top).offset(-24)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        input.isWordsUpdating
            .drive(rx.isWordsUpdating)
            .disposed(by: disposeBag)
        
        input.lexickonState
            .drive(rx.lexickonStatus)
            .disposed(by: disposeBag)
        
        wordsStateButton.configure(
            input: .init(
                state: input.lexickonState
            )
        )
        
        return Output(didTap: wordsStateButton.rx.tap.asSignal())
    }
}

private extension Reactive where Base : HomeHeaderView {
    
    var isWordsUpdating: Binder<Bool> {
        Binder(base) { base, isWordsUpdating in
            UIView.animate(withDuration: 0.3) {
                base.infoLabel.alpha = isWordsUpdating ? 0 : 1
                base.wordsStateButton.alpha = isWordsUpdating ? 0 : 1
            }
        }
    }
    
    var lexickonStatus: Binder<LexickonStateEntity.State> {
        Binder(base) { base, status in
            UIView.animate(withDuration: 0.3) {
                switch status {
                case .hasFireWords:
                    base.backgroundColor = Colors.hasFireWordsHeader.color
                default:
                    base.backgroundColor = Colors.mainBG.color
                }
            }
        }
    }
}
