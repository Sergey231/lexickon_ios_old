//
//  LXButtonStyles.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 13.10.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct LXFilledButtonStyle: ButtonStyle {
    
    var disabled: Bool  = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(
                width: Constants.Sizes.button.width,
                height: Constants.Sizes.button.height,
                alignment: .center)
            .foregroundColor(Color.green)
            .background(Color.white)
            .clipShape(Capsule())
            .padding(Constants.Margin.small)
            .opacity(disabled == true ? 0.5 : 1)
    }
}
