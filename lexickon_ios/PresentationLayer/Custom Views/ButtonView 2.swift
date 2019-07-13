//
//  Button.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/11/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct ButtonView : View {
    var body: some View {
        
        Button("Button") {
            print("button")
        }.frame(
            width: 280,
            height: 56,
            alignment: .center
        )
        .background(Color.red)
            .cornerRadius(28) {
                Text("title")
        }
    }
}

#if DEBUG
struct ButtonView_Previews : PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
#endif
