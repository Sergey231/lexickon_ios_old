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
import LexickonStateEntity

public final class WordsStateButton: UIButton {
    
    public struct Input {
        let state: Driver<LexickonStateEntity.State>
    }
    
    fileprivate let stateLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
        self.createUI()
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
        
        stateLabel.setup {
            $0.textAlignment = .center
            $0.textColor = Colors.mainBG.color
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        
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
    
    var state: Binder<LexickonStateEntity.State> {
        Binder(base) { base, state in
            print("✅ \(state)")
            switch state {
            case .hasReadyWords:
                base.stateLabel.text = "Слова готовы!"
            case .hasFireWords:
                base.stateLabel.text = "Срочно повторить!"
            case .waiating:
                base.stateLabel.text = "Слов созревают..."
            case .empty:
                base.stateLabel.text = "У вас пока нет слов"
            }
        }
    }
}

