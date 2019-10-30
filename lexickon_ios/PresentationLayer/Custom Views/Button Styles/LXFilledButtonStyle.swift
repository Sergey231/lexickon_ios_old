//
//  LXButtonStyles.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 13.10.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct LXFilledButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(
                width: Constants.Sizes.button.width,
                height: Constants.Sizes.button.height,
                alignment: .center)
            .foregroundColor(Asset.Colors.mainBG)
            .background(Color.white)
            .clipShape(Capsule())
            .padding(8)
    }
}
