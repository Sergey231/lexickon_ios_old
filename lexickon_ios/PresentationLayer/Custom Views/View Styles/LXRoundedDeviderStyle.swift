//
//  LXRoundedDeviderStyle.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 13.10.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct LXRoundedDeviderStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(height: 2)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}
