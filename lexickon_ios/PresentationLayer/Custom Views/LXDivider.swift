//
//  DividerView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 9/18/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct LXDivider: View {
    
    private let tintColor: Color
    private let width: CGFloat
    private let rounded: Bool
    
    init(
        tintColor: Color = Color.gray,
        width: CGFloat = 0.5,
        rounded: Bool = false
    ) {
        self.tintColor = tintColor
        self.width = width
        self.rounded = rounded
    }
    
    private var cornerRadius: CGFloat {
        return rounded
        ? width/2
        : 0
    }
    
    var body: some View {
        
        Rectangle()
            .frame(height: width)
            .foregroundColor(tintColor)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 54) {
            
            LXDivider()
            
            LXDivider(width: 2)
            
            LXDivider(width: 4)
            
            LXDivider(width: 8)
            
            LXDivider(width: 8, rounded: true)
            
            LXDivider(tintColor: Asset.Colors.mainBG)
            
            LXDivider(tintColor: Asset.Colors.mainBG, width: 2)
            
            LXDivider(tintColor: Asset.Colors.mainBG, width: 4)
            
            LXDivider(tintColor: Asset.Colors.mainBG, width: 8)
            
            LXDivider(tintColor: Asset.Colors.mainBG, width: 8, rounded: true)
            
        }.padding()
    }
}
