//
//  LXRoundedWhiteButtonStyle.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 13.10.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct LXRoundedWhiteButtonStyle: ButtonStyle {
    
    var disabled: Bool  = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .frame(
                width: Constants.Sizes.button.width,
                height: Constants.Sizes.button.height,
                alignment: .center)
            .foregroundColor(.white)
            .background(Asset.Colors.mainBG)
            .overlay(Capsule().stroke(lineWidth: 2).foregroundColor(.white))
            .padding(Constants.Margin.small)
            .opacity(disabled == true ? 0.5 : 1)
    }
}
