//
//  StartLogoView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/9/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct StartLogoView : View {
    var body: some View {
        ZStack {
            
            VStack {
                
                Image("Logo")
                Image("TextLogo")
            }
        }
        .frame(
            width: 200,
            height: 200,
            alignment: .center
        )
        
    }
}

#if DEBUG
struct StartLogoView_Previews : PreviewProvider {
    static var previews: some View {
        StartLogoView()
    }
}
#endif
