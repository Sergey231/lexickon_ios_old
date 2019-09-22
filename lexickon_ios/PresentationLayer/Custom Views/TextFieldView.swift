//
//  TextFieldView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 9/15/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI
import Combine

struct TextFieldView: View {
    
    @Binding var value: String
    @State var placeholder: String = "Type here"
    @State var icon: Image?
    @State var tintColor: Color = .black
    
    @State private var isShowPlaceholder: Bool = true
    
    private let textFieldHeight: CGFloat = 72
    private var iconSize: CGFloat {
        return icon == nil ? 0 : 24
    }
    
    private var textFieldPlaceholder: some View {
        return Text(placeholder)
            .foregroundColor(tintColor)
            .opacity(0.5)
            .padding(.trailing, iconSize)
            .padding(.leading, -iconSize)
    }
    
    private var textFieldIcon: some View {
        return icon
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(tintColor)
    }
    
    private var textField: some View {
        return TextField("", text: $value,
                         onEditingChanged: { isChanged in
                            self.isShowPlaceholder = !isChanged
        })
            .frame(height: textFieldHeight)
            .multilineTextAlignment(.center)
            .foregroundColor(tintColor)
            .padding(.trailing, iconSize)
            .padding(.leading, -iconSize)
    }
    
    private var divider: some View {
        return DividerView(
            tintColor: tintColor,
            width: 2,
            rounded: true
        )
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                textFieldIcon.padding()
                    
                ZStack {
                    
                    if isShowPlaceholder {
                        textFieldPlaceholder
                    }
                    
                    textField
                }
                
            }.padding([.bottom], -16)
            
            divider
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    
    static var previews: some View {
        ZStack {
            Asset.Colors.mainBG
            
            VStack {
                TextFieldView(
                    value: Binding<String>.constant("Test text"),
                    icon: Asset.Images.accountOutline,
                    tintColor: .white
                ).padding([.trailing, .leading])
                
                TextFieldView(
                    value: Binding<String>.constant(""),
                    icon: Asset.Images.accountOutline,
                    tintColor: .white
                ).padding([.trailing, .leading], 32)
                
                TextFieldView(
                    value: Binding<String>.constant(""),
                    placeholder: "Placeholder",
                    tintColor: .white
                ).padding([.trailing, .leading], 64)
            }
        }
    }
}
