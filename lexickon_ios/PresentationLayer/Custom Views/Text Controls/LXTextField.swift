//
//  LXTextField.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 9/15/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI
import Combine

struct LXTextField: View {
    
    final class Input: ObservableObject {
        
        var value: Binding<String>
        @Published var placeholder: String
        @Published var icon: Image?
        @Published var tintColor: Color
        
        init(
            value: Binding<String>,
            placeholder: String = "Type here",
            icon: Image? = nil,
            tintColor: Color = .black
        ) {
            self.value = value
            self.placeholder = placeholder
            self.icon = icon
            self.tintColor = tintColor
        }
    }
    
    @ObservedObject var input: Input
    
    @State private var isShowPlaceholder: Bool = true
    
    private let textFieldHeight: CGFloat = 72
    private var iconSize: CGFloat {
        return input.icon == nil ? 0 : 24
    }
    
    private var textFieldIcon: some View {
        return input.icon
            .frame(width: iconSize, height: iconSize)
            .foregroundColor(input.tintColor)
    }
    
    private var textField: some View {
        return TextField(
            input.placeholder,
            text: input.value,
            onEditingChanged: { isChanged in
                self.isShowPlaceholder = !isChanged
        })
            .frame(height: textFieldHeight)
            .multilineTextAlignment(.center)
            .foregroundColor(input.tintColor)
            .padding(.trailing, iconSize)
            .padding(.leading, -iconSize)
    }
    
    private var divider: some View {
        return LXDivider(
            tintColor: input.tintColor,
            width: 2,
            rounded: true
        )
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                textFieldIcon.padding()
                textField
                
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
                LXTextField(
                    input: LXTextField.Input(
                        value: .constant("Test text"),
                        icon: Asset.Images.accountOutline,
                        tintColor: .white
                    )
                ).padding([.trailing, .leading], 16)

                LXTextField(
                    input: LXTextField.Input(
                        value: .constant(""),
                        icon: Asset.Images.accountOutline,
                        tintColor: .white
                    )
                ).padding([.trailing, .leading], 32)

                LXTextField(
                    input: LXTextField.Input(
                        value: .constant(""),
                        placeholder: "Placeholder",
                        tintColor: .white
                    )
                ).padding([.trailing, .leading], 64)
            }
        }
    }
}
