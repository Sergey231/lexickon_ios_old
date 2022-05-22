//
//  TextField.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import RxExtensions
import SnapKit

public final class LXTextField: UIView {
    
    public struct Input {
        let placeholder: String
        let leftIcon: UIImage?
        let rightIcon: UIImage?
        let isSecure: Bool
        let keyboardType: UIKeyboardType
        let returnKeyType: UIReturnKeyType
        let initValue: String
        let lineColor: UIColor
        let lineIsVisibleBySelectedTextField: Bool
        
        public init(
            placeholder: String = "",
            leftIcon: UIImage? = nil,
            rightIcon: UIImage? = nil,
            isSecure: Bool = false,
            keyboardType: UIKeyboardType = .asciiCapable,
            returnKeyType: UIReturnKeyType = .join,
            initValue: String = "",
            lineColor: UIColor = .white,
            lineIsVisibleBySelectedTextField: Bool = false
        ) {
            self.placeholder = placeholder
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.isSecure = isSecure
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.initValue = initValue
            self.lineColor = lineColor
            self.lineIsVisibleBySelectedTextField = lineIsVisibleBySelectedTextField
        }
        
        var leftIconWidth: CGFloat {
            leftIcon != nil
                ? Size.icon.width
                : 0
        }
        
        var rightIconWidth: CGFloat {
            rightIcon != nil
                ? Size.icon.width
                : 0
        }
        
        var hTextFieldMargin: CGFloat {
            rightIcon != nil || leftIcon != nil
                ? Size.icon.width
                : 0
        }
        
        var eyeIconWidth: CGFloat {
            isSecure
                ? Size.icon.width
                : 0
        }
    }
    
    public let textField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = .white
        textField.tintColor = .white
        return textField
    }()
    private let leftIconView = UIImageView()
    private let rightIconView = UIImageView()
    private let eyeIconButton = CheckBox()
    private let lineView = UIView()
    
    private var _input: Input?
    private let disposeBag = DisposeBag()
    
    private let eyeIcon = BehaviorRelay<UIImage>(value: Images.eyeHideIcon.image)
    
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
            textField,
            leftIconView,
            rightIconView,
            eyeIconButton,
            lineView
        )
    }
    
    private func configureUI() {
        leftIconView.contentMode = .scaleAspectFit
        rightIconView.contentMode = .scaleAspectFit
        leftIconView.tintColor = .white
        rightIconView.tintColor = .white
    }
    
    public func configure(input: Input) {
        
        _input = input
        
        lineView.backgroundColor = input.lineColor
        
        setupConstraints(input)
        
        textField.attributedPlaceholder = NSAttributedString(
            string: input.placeholder,
            attributes: [.foregroundColor: Colors.placeholder.color]
        )
        textField.keyboardType = input.keyboardType
        textField.returnKeyType = input.returnKeyType
        textField.text = input.initValue
        textField.isSecureTextEntry = input.isSecure
        leftIconView.image = input.leftIcon
        rightIconView.image = input.rightIcon
        
        eyeIconButton.configure(input: .init(
            onIcon: Images.eyeHideIcon.image,
            offIcon: Images.eyeShowIcon.image
        ))
        
        eyeIconButton.on
            .map { input.isSecure ? $0 : false }
            .drive(textField.rx.isSecureTextEntry)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(UIControl.Event.editingDidBegin)
            .filter { _ in input.lineIsVisibleBySelectedTextField }
            .asDriver(onErrorDriveWith: .empty())
            .map { 1 }
            .drive(lineView.rx.alphaAnimated)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(UIControl.Event.editingDidEnd)
            .map { _ in () }
            .startWith(())
            .filter { _ in input.lineIsVisibleBySelectedTextField }
            .asDriver(onErrorDriveWith: .empty())
            .map { 0 }
            .drive(lineView.rx.alphaAnimated)
            .disposed(by: disposeBag)
        
        lineView.round()
    }
    
    private func setupConstraints(_ input: Input) {
        
        leftIconView.snp.makeConstraints {
            $0.size.equalTo(input.leftIconWidth)
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        eyeIconButton.snp.makeConstraints {
            $0.size.equalTo(input.eyeIconWidth)
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        rightIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(input.rightIconWidth)
            $0.right.equalTo(eyeIconButton.snp.left)
        }

        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Size.textField.height)
            $0.right.equalTo(-input.hTextFieldMargin)
            $0.left.equalTo(input.hTextFieldMargin)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(Size.line.height)
        }
    }
}

extension LXTextField: EnumerableTextField {}

public extension Reactive where Base: LXTextField {
    var sbmitText: Driver<String> {
        return Driver.merge(
            base.textField.rx.controlEvent(.editingChanged).asDriver(),
            base.textField.rx.controlEvent(.editingDidEnd).asDriver()
        )
            .map { _ in base.textField.text ?? "" }
    }
}
