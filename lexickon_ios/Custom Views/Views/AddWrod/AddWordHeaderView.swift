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
    
    private enum UIConstants {
        static let minTextFieldHeight = AddSearchWordTextField.UIConstants.minHeight
    }
    
    struct Output {
        let backButtonDidTap: Signal<Void>
        let height: Driver<CGFloat>
        let text: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.Images.backArrow.image, for: .normal)
        return button
    }()
    
    private let addSearchWordTextField = AddSearchWordTextField()
    private var textViewHeight: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        backButton.snp
            .makeConstraints {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                $0.size.equalTo(56)
                $0.left.equalToSuperview()
            }
        
        addSearchWordTextField.snp
            .makeConstraints {
                $0.top.equalTo(self.backButton.snp.bottom)
                $0.left.equalTo(Margin.regular)
                $0.right.equalTo(-Margin.regular)
                self.textViewHeight = $0.height.greaterThanOrEqualTo(UIConstants.minTextFieldHeight)
                    .constraint
            }
    }
    
    func configure() -> Output {
        
        let addSearchWordOutput = addSearchWordTextField.configure()
        
        addSearchWordOutput.height
            .drive(onNext: {
                self.textViewHeight?.update(priority: $0)
            })
            .disposed(by: disposeBag )
        
        let height = Driver.combineLatest(
            rx.size.take(1).asDriver(onErrorJustReturn: CGSize.zero),
            addSearchWordOutput.height
        )
            .map { size, addSearchWordHeight in
                size.height + (addSearchWordHeight - UIConstants.minTextFieldHeight)
            }
        
        let text = addSearchWordOutput.text
            .map { $0 ?? "" }
            .asDriver(onErrorJustReturn: "")
        
        return Output(
            backButtonDidTap: backButton.rx.tap.asSignal(),
            height: height,
            text: text
        )
    }
}
