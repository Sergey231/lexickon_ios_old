//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 28.08.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import RxExtensions
import SnapKit
import Assets
import LBTATools

public final class ExercisesTitleView: UIView {
    
    fileprivate struct UIConstants {
        static let progressViewHeight: CGFloat = 12
        static let progressViewWidth = UIScreen.main.bounds.width - (44 + 16 + 16)
    }
    
    public struct Input {
        public init(value: Driver<CGFloat>) {
            self.value = value
        }
        let value: Driver<CGFloat>
    }
    
    public struct Output {
        public let closeDidTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let closeButton = UIButton()
    private let progressContainerView = UIView()
    fileprivate let progressView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        closeButton.setImage(Images.closeIcon.image, for: .normal)
        closeButton.tintColor = .gray

        progressContainerView.backgroundColor = .yellow
        
        progressView.setup {
            $0.backgroundColor = Colors.mainBG.color
            $0.layer.cornerRadius = UIConstants.progressViewHeight/2
            progressContainerView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.width.equalTo(0)
                $0.height.equalTo(UIConstants.progressViewHeight)
            }
        }
        
        hstack(
            progressContainerView.withWidth(UIConstants.progressViewWidth),
            closeButton.withWidth(44)
        )
    }
    
    public func configure(input: Input) -> Output {
        input.value
            .drive(rx.progress)
            .disposed(by: disposeBag)
        return Output(closeDidTap: closeButton.rx.tap.asSignal())
    }
}

extension Reactive where Base: ExercisesTitleView {
    var progress: Binder<CGFloat> {
        Binder(base) { base, value in
            UIView.animate(withDuration: 0.3) {
                base.progressView.snp.updateConstraints {
                    let scaleViewMaxWidth = ExercisesTitleView.UIConstants.progressViewWidth
                    let currentProgressWidth = scaleViewMaxWidth * value
                    $0.width.equalTo(currentProgressWidth)
                }
                base.progressView.superview?.layoutIfNeeded()
            }
        }
    }
}
