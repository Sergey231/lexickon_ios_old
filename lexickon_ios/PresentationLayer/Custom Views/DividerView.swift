//
//  DividerView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 9/18/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct DividerView: View {
    
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
            
            DividerView()
            
            DividerView(width: 2)
            
            DividerView(width: 4)
            
            DividerView(width: 8)
            
            DividerView(width: 8, rounded: true)
            
            DividerView(tintColor: Asset.Colors.mainBG)
            
            DividerView(tintColor: Asset.Colors.mainBG, width: 2)
            
            DividerView(tintColor: Asset.Colors.mainBG, width: 4)
            
            DividerView(tintColor: Asset.Colors.mainBG, width: 8)
            
            DividerView(tintColor: Asset.Colors.mainBG, width: 8, rounded: true)
            
        }.padding()
    }
}
