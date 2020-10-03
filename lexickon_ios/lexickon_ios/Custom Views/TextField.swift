//
//  TextField.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 11.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import CombineCocoa
import UIExtensions

final class TextField: UIView {
    
    struct Input {
        let placeholder: String
        let leftIcon: UIImage?
        let rightIcon: UIImage?
        let isSecure: Bool
        let keyboardType: UIKeyboardType
        let returnKeyType: UIReturnKeyType
        let initValue: String
        
        init(
            placeholder: String = "",
            leftIcon: UIImage? = nil,
            rightIcon: UIImage? = nil,
            isSecure: Bool = false,
            keyboardType: UIKeyboardType = .asciiCapable,
            returnKeyType: UIReturnKeyType = .join,
            initValue: String = ""
        ) {
            self.placeholder = placeholder
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
            self.isSecure = isSecure
            self.keyboardType = keyboardType
            self.returnKeyType = returnKeyType
            self.initValue = initValue
        }
        
        var leftIconWidth: CGFloat {
            return leftIcon != nil
                ? Sizes.icon.width
                : 0
        }
        
        var rightIconWidth: CGFloat {
            return rightIcon != nil
                ? Sizes.icon.width
                : 0
        }
        
        var hTextFieldMargin: CGFloat {
            return rightIcon != nil && leftIcon != nil
                ? Sizes.icon.width
                : 0
        }
    }
    
    internal let textField = UITextField()
    private let leftIconView = UIImageView()
    private let rightIconView = UIImageView()
    private let lineView = UIView()
    
    private var _input: Input?
    
    //MARK: init programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    //MAEK: init from XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
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
            lineView
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    private func configureUI() {
        textField.textAlignment = .center
        textField.textColor = .white
        leftIconView.contentMode = .scaleAspectFit
        rightIconView.contentMode = .scaleAspectFit
        leftIconView.tintColor = .white
        rightIconView.tintColor = .white
        lineView.backgroundColor = .white
    }
    
    func configure(input: Input) {
        
        _input = input 
        layout()
        textField.tintColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: input.placeholder,
            attributes: [.foregroundColor: Asset.Colors.whiteAlpha07.color]
        )
        textField.keyboardType = input.keyboardType
        textField.returnKeyType = input.returnKeyType
        textField.text = input.initValue
        textField.isSecureTextEntry = input.isSecure
        leftIconView.image = input.leftIcon
        rightIconView.image = input.rightIcon
        lineView.round()
    }
    
    private func layout() {
        
        leftIconView.pin
            .vCenter()
            .size(_input?.leftIconWidth ?? 0)
            .left()
        
        rightIconView.pin
            .vCenter()
            .size(_input?.rightIconWidth ?? 0)
            .right()
        
        textField.pin
            .vCenter()
            .height(Sizes.uiTextField.height)
            .horizontally(_input?.hTextFieldMargin ?? 0)
            .marginHorizontal(Margin.small)
        
        lineView.pin
            .below(of: [leftIconView, rightIconView, textField])
            .height(Sizes.line.height)
            .horizontally()
    }
}

extension TextField: EnumerableTextField {}

extension TextField: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return TextField()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct TextField_Previews: PreviewProvider {
    static var previews: some View {
        TextField()
    }
}
