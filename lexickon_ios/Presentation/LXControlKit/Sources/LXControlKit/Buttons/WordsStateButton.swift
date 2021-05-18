//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 17.05.2021.
//

import UIKit
import UIExtensions
import Assets
import SnapKit
import RxCocoa
import RxSwift

public final class WordsStateButton: UIButton {
    
    public enum State {
        case hasReadyWords
        case hasFireWords
        case waiating
    }
    
    public struct Input {
        let state: Driver<State>
    }
    
    private let disposeBag = DisposeBag()
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
        self.createUI()
        self.configure(input: .init(state: .just(.hasReadyWords)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        backgroundColor = .white
        
        snp.makeConstraints {
            $0.width.equalTo(280)
            $0.height.equalTo(90)
        }
        
        rx.size
            .asDriver(onErrorDriveWith: .empty())
            .map { $0.height/2 }
            .drive(rx.cornerRadius)
            .disposed(by: disposeBag)
    }
    
    private func configure(input: Input) {
        
        input.state
            .drive(rx.state)
            .disposed(by: disposeBag)
    }
}

private extension Reactive where Base: WordsStateButton {
    var cornerRadius: Binder<CGFloat> {
        Binder(base) { base, cornerRadius in
            base.layer.cornerRadius = cornerRadius
        }
    }
    
    var state: Binder<WordsStateButton.State> {
        Binder(base) { base, state in
            print("✅ \(state)")
        }
    }
}

