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
import RxExtensions
import SnapKit
import Assets

public final class AddWordHeaderView: UIView {
    
    private enum UIConstants {
        static let minTextFieldHeight = AddSearchWordTextField.UIConstants.minHeight
        static let backButtonSize: CGFloat = 56
    }
    
    public struct Output {
        public let backButtonDidTap: Signal<Void>
        public let height: Driver<CGFloat>
        public let text: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    
    public var backButton = UIButton()
    
    private let titleView = MultiLabelView()
    private let addSearchWordTextField = AddSearchWordTextField()
    private var textViewHeight: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = Asset.Colors.mainBG.color
        
        backButton.setup {
            addSubview($0)
            $0.setImage(Asset.Images.backArrow.image, for: .normal)
            $0.snp.makeConstraints {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                $0.size.equalTo(UIConstants.backButtonSize)
                $0.left.equalToSuperview()
            }
        }
        
        addSearchWordTextField.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(self.backButton.snp.bottom)
                $0.left.equalTo(Margin.regular)
                $0.right.equalTo(-Margin.regular)
                self.textViewHeight = $0.height.greaterThanOrEqualTo(UIConstants.minTextFieldHeight)
                    .constraint
            }
        }
        
        titleView.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalTo(backButton.snp.right)
                $0.centerY.equalTo(backButton.snp.centerY)
                $0.height.equalTo(backButton.snp.height)
                $0.right.equalToSuperview().offset(-UIConstants.backButtonSize)
            }
        }
    }
    
    public func configure() -> Output {
        
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
        
        titleView.configure(
            MultiLabelView.Input(titles: ["Добавить слова", "Найти слова"])
        )
        
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
