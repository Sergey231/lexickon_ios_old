//
//  LXTextFieldStyle.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 13.10.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct LXTextFieldStyle: ViewModifier {
    
    var leftIcon: Image?
    var rightIcon: Image?
    
    private var leftIconView: some View {
        return leftIcon
            .frame(width: 24, height: 24)
            .foregroundColor(.white)
    }
    
    private var rightIconView: some View {
        return rightIcon
            .frame(width: 24, height: 24)
            .foregroundColor(.white)
    }
    
    var contentPadding: CGFloat {
        return (leftIcon != nil || rightIcon != nil) ? 48 : 0
    }
        
    
    private var divider: some View {
        return Rectangle().modifier(LXRoundedDeviderStyle())
    }
    
    func body(content: Content) -> some View {
        
        VStack {
            
            ZStack {
                
                HStack {
                    leftIconView.padding()
                    Spacer()
                    rightIconView.padding()
                }
                
                content
                .frame(height: 72)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                    .padding( .horizontal, contentPadding)
                
            }.padding([.bottom], -16)
            
            divider
        }.padding(.horizontal, 40)
    }
}

