//
//  WordCardTopBarView.swift
//  
//
//  Created by Sergey Borovikov on 15.06.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import Assets
import LexickonApi

public final class WordCardTopBarView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(studyState: Driver<LxStudyState>) {
            self.studyState = studyState
        }
        let studyState: Driver<LxStudyState>
    }
    
    public struct Output {
        public let didTapBack: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let backButton = UIButton()
    fileprivate let titleLabel = UILabel()
    fileprivate let moreButton = MoreButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        backgroundColor = .gray
        snp.makeConstraints {
            let safeAreaTop = UIApplication.shared.windows[0].safeAreaInsets.top
            $0.height.equalTo(safeAreaTop + 48)
        }
        
        titleLabel.setup {
            $0.textAlignment = .center
            $0.textColor = .white
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.huge)
                $0.right.equalToSuperview().offset(-Margin.huge)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(Size.textField.height)
            }
        }
        
        moreButton.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(titleLabel.snp.right).offset(Margin.small)
                $0.centerY.equalTo(titleLabel.snp.centerY)
            }
        }
        
        backButton.setup {
            $0.setImage(Images.backArrow.image, for: .normal)
            addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalTo(titleLabel.snp.centerY)
                $0.size.equalTo(56)
                $0.right.equalTo(titleLabel.snp.left)
            }
        }
    }
    
    public func configure(input: Input) -> Output {
        
        input.studyState
            .drive(rx.studyState)
            .disposed(by: disposeBag)
        
        return Output(didTapBack: backButton.rx.tap.asSignal())
    }
}

private extension Reactive where Base : WordCardTopBarView {
    var studyState: Binder<LxStudyState> {
        Binder(base) { base, studyState in
            switch studyState {
            case .fire, .downgradeRating:
                base.titleLabel.text = Str.wordCardFireStateTitle
                base.backgroundColor = Colors.fireWordBG.color
            case .ready:
                base.titleLabel.text = Str.wordCardReadyStateTitle
                base.backgroundColor = Colors.mainBG.color
            case .new:
                base.titleLabel.text = Str.wordCardNewStateTitle
                base.backgroundColor = Colors.newWordBG.color
            case .waiting:
                base.titleLabel.text = Str.wordCardWaitingStateTitle
                base.backgroundColor = Colors.waitingWordBG.color
            }
        }
    }
}

