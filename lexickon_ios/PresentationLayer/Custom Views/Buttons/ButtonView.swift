//
//  Button.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/11/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct ButtonView : View {
    
    enum Style {
        case filled(bgColor: Color, labelColor: Color)
        case normal(tintColor: Color)
    }
    
    init(
        title: String = "Button Lable",
        style: Style = .normal(tintColor: Asset.Colors.mainBG),
        action: (() -> ())? = nil
    ) {
        
        switch style {
            
        case .normal(let tintColor):
            self.titleColor = tintColor
            self.bgColor = Color.clear
            self.borderColor = titleColor
            
        case .filled(let bgColor, let labelColor):
            self.titleColor = labelColor
            self.bgColor = bgColor
            self.borderColor = bgColor
        }
        self.title = title
        self.action = action
    }
    
    private let bgColor: Color
    private let title: String
    private let titleColor: Color
    private let borderColor: Color
    private let action: (() -> ())?
    
    private var bgViewOverlay: some View {
        return RoundedRectangle(cornerRadius: Constants.Sizes.button.height/2)
            .stroke(lineWidth: 2)
            .foregroundColor(borderColor)
    }
    
    private var bgViewClipShape: some Shape {
        return RoundedRectangle(cornerRadius: Constants.Sizes.button.height/2)
    }
    
    private var bgView: some View {
        return Rectangle()
            .frame(
                width: Constants.Sizes.button.width,
                height: Constants.Sizes.button.height,
                alignment: .center)
            .foregroundColor(bgColor)
            .clipShape(bgViewClipShape)
            .overlay(bgViewOverlay)
    }
    
    private var buttonTitle: some View {
        return Text(title)
            .foregroundColor(titleColor)
            .fontWeight(.bold)
    }
    
    var body: some View {
        
        Button(action: { self.action?() }) {
            ZStack {
                bgView
                buttonTitle
            }
        }
    }
}

#if DEBUG
struct ButtonView_Previews : PreviewProvider {
    static var previews: some View {
        VStack {
            ButtonView(
                title: "Filled Style",
                style: .filled(
                    bgColor: Asset.Colors.mainBG,
                    labelColor: Color.white
                )
            )
            
            ButtonView(
                title: "Normal Style",
                style: .normal(
                    tintColor: Asset.Colors.mainBG
                )
            )
        }
    }
}
#endif
