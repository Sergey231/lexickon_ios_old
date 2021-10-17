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
    
    private struct UIConstants {
        static let progressViewHeight: CGFloat = 12
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
    private let scaleView = UIView()
    private let progressView = UIView()
    
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

        let scaleViewWidth = UIScreen.main.bounds.width - (44 + 8 + 8)
        scaleView.backgroundColor = .yellow
        
        progressView.setup {
            $0.backgroundColor = Colors.mainBG.color
            $0.layer.cornerRadius = UIConstants.progressViewHeight/2
            scaleView.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.width.equalTo(100)
                $0.height.equalTo(UIConstants.progressViewHeight)
            }
        }
        
        hstack(
            scaleView.withWidth(scaleViewWidth),
            closeButton.withWidth(44)
        )
    }
    
    public func configure(input: Input) -> Output {
        
        return Output(closeDidTap: closeButton.rx.tap.asSignal())
    }
}
