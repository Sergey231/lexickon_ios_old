//
//  StartLogoView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/9/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct StartLogoView : View {
    
    @State var animate = false
    
    var body: some View {
        
        ZStack {
            
            Asset.Images.imageLogo
                .scaleEffect(animate ? 1 : 1.5)
                .padding(.bottom, animate ? 260 : 0)
                .animation(.spring())
            
            Asset.Images.textLogo
                .opacity(animate ? 1 : 0)
                .animation(Animation.easeInOut(duration: 1))
                .padding(.bottom, 100)
        }
        .frame(
            width: 200,
            height: 430,
            alignment: .center
        ).onAppear {
            self.animate = true
        }
        
    }
}

#if DEBUG
struct StartLogoView_Previews : PreviewProvider {
    static var previews: some View {
        
        StartLogoView()
            .previewLayout(.fixed(width: 200, height: 430))
            .background(Asset.Colors.mainBG)
    }
}
#endif
