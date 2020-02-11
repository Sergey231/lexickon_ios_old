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

final class TextField: UIView {
    
    struct Input {
        let placeholder: String
        let leftIcon: UIImage?
        let rightIcon: UIImage?
        
        init(
            placeholder: String = "",
            leftIcon: UIImage? = nil,
            rightIcon: UIImage? = nil
        ) {
            self.placeholder = placeholder
            self.leftIcon = leftIcon
            self.rightIcon = rightIcon
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
    }
    
    private let textField = UITextField()
    private let leftIconView = UIImageView()
    private let rightIconView = UIImageView()
    private let lineView = UIView()
    
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
        backgroundColor = .gray
        createUI()
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
        configure(input: Input())
    }
    
    func configure(input: Input) {
        
        leftIconView.image = input.leftIcon
        rightIconView.image = input.rightIcon
        leftIconView.tintColor = .white
        lineView.backgroundColor = .white
        
        leftIconView.pin
            .vCenter()
            .size(input.leftIconWidth)
            .left()
        
        rightIconView.pin
            .vCenter()
            .size(input.rightIconWidth)
            .right()
        
        textField.pin
            .vCenter()
            .height(Sizes.textField.height)
            .after(of: leftIconView)
            .margin(Margin.small)
            .before(of: rightIconView)
            .margin(Margin.small)
        
        lineView.pin
            .below(of: [leftIconView, rightIconView, textField])
            .height(Sizes.line.height)
            .horizontally()
        
        lineView.round()
    }
}

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
