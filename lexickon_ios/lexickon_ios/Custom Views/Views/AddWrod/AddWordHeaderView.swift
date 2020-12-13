//
//  AddWordHeaderView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import SnapKit

final class AddWordHeaderView: UIView {
    
    struct Output {
        let backButtonDidTap: Signal<Void>
        let height: Driver<CGFloat>
    }
    
    private let disposeBag = DisposeBag()
    
    let backButton = UIButton()
    private let addSearchWordTextField = AddSearchWordTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backButton.pin
            .top(pin.safeArea.top)
            .left()
            .size(56)
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            addSearchWordTextField,
            backButton
        )
    }
    
    private func configureUI() {
        backgroundColor = Asset.Colors.mainBG.color
        backButton.setImage(Asset.Images.backArrow.image, for: .normal)
        
    }
    
    func configure() -> Output {
        
        let addSearchWordHeight = addSearchWordTextField.configure()
            .height
        
        rx.layoutSubviews
            .withLatestFrom(addSearchWordHeight)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                self.addSearchWordTextField.pin
                    .below(of: self.backButton)
                    .horizontally(Margin.mid)
                    .height($0)
            })
            .disposed(by: disposeBag)
        
        let height = addSearchWordHeight
            .map { self.frame.size.height - ($0 + Margin.regular) }
        
        return Output(
            backButtonDidTap: backButton.rx.tap.asSignal(),
            height: height
        )
    }
}
