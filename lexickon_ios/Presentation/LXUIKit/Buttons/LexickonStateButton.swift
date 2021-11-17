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

public final class LexickonStateButton: UIButton {
    
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

private extension Reactive where Base: LexickonStateButton {
    var cornerRadius: Binder<CGFloat> {
        Binder(base) { base, cornerRadius in
            base.layer.cornerRadius = cornerRadius
        }
    }
    
    var state: Binder<LexickonStateEntity.State> {
        Binder(base) { base, state in
            switch state {
            case .hasReadyWords:
                base.stateLabel.text = "готовы к испытаниям!"
                base.stateLabel.textColor = Colors.readyWordBright.color
            case .hasFireWords:
                base.stateLabel.text = "нужно срочно повторить!"
                base.stateLabel.textColor = Colors.fireWordBright.color
            case .waiating:
                base.stateLabel.text = "осталось до занятия"
                base.stateLabel.textColor = Colors.readyWordBright.color
            case .empty:
                base.stateLabel.text = ""
                base.stateLabel.textColor = Colors.readyWordBright.color
            }
        }
    }
}

