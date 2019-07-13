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
        Image("Logo")
    }
}

#if DEBUG
struct StartLogoView_Previews : PreviewProvider {
    static var previews: some View {
        StartLogoView()
    }
}
#endif
