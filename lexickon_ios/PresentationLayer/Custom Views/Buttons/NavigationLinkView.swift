//
//  NavigationLinkView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/31/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct NavigationLinkView: View {
    
    enum Style {
        case filled(bgColor: Color, labelColor: Color)
        case normal(tintColor: Color)
    }
    
    init<V>(
        destination: V,
        title: String = "Button Lable",
        style: Style = .normal(tintColor: Asset.Colors.mainBG)) where V: View {
        
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
        self.destination = AnyView(destination)
    }
    
    private let bgColor: Color
    private let title: String
    private let titleColor: Color
    private let borderColor: Color
    
    private let destination: AnyView
    
    var body: some View {
        
        NavigationLink(
        destination: destination) {
            ZStack {
                Rectangle()
                    .frame(
                        width: Constants.Sizes.button.width,
                        height: Constants.Sizes.button.height,
                        alignment: .center)
                    .foregroundColor(bgColor)
                    .clipShape(RoundedRectangle(
                        cornerRadius: Constants.Sizes.button.height/2))
                    .overlay(RoundedRectangle(
                        cornerRadius: Constants.Sizes.button.height/2)
                        .stroke(lineWidth: 2)
                    .foregroundColor(borderColor))
                
                Text(title)
                    .foregroundColor(titleColor)
                    .fontWeight(.bold)
            }
        }
    }
}

#if DEBUG
struct NavigationLinkView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationLinkView(
                destination: Text("Hello World!"),
                title: "Filled Style",
                style: .filled(
                    bgColor: Asset.Colors.mainBG,
                    labelColor: Color.white
                )
            )
            
            NavigationLinkView(
                destination: Text("Hello World!"),
                title: "Normal Style",
                style: .normal(
                    tintColor: Asset.Colors.mainBG
                )
            )
        }
    }
}
#endif
