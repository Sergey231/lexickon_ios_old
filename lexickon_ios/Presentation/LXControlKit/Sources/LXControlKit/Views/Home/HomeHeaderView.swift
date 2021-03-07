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

public final class HomeHeaderView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(
            isWordsUpdating: Driver<Bool>
        ) {
            self.isWordsUpdating = isWordsUpdating
        }
        let isWordsUpdating: Driver<Bool>
    }
    
    public struct Output {
        let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    
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
        
        button.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        infoLabel.setup {
            $0.text = "Header is developing 😐"
            $0.textAlignment = .center
            $0.textColor = .white
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        input.isWordsUpdating
            .drive(rx.isWordsUpdating)
            .disposed(by: disposeBag)
        
        return Output(didTap: button.rx.tap.asSignal())
    }
}

private extension Reactive where Base : HomeHeaderView {
    
    var isWordsUpdating: Binder<Bool> {
        Binder(base) { base, isWordsUpdating in
            UIView.animate(withDuration: 0.3) {
                base.infoLabel.alpha = isWordsUpdating ? 0 : 1
            }
        }
    }
}
