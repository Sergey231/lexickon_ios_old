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
    
    public struct Input {
        public init() {}
    }
    
    public struct Output {
        public let closeDidTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let closeButton = UIButton()
    private let scaleView = UIView()
    
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
        closeButton.backgroundColor = .red

        let scaleViewWidth = UIScreen.main.bounds.width - (44 + 8 + 8)
        scaleView.backgroundColor = .yellow
        
        hstack(
            scaleView.withWidth(scaleViewWidth),
            closeButton.withWidth(44)
        )
    }
    
    public func configure(input: Input) -> Output {
        
        return Output(closeDidTap: closeButton.rx.tap.asSignal())
    }
}
