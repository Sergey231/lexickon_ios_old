//
//  StartView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct StartView : View {
    
    private var presenter: StartPresenterProtocol
    
    init(presenter: StartPresenterProtocol) {
        self.presenter = presenter
    }
    
    var body: some View {
        ZStack {
            // background color
            Color.init("mainBG").edgesIgnoringSafeArea(.all)
            
            
        }
    }
}

#if DEBUG
struct StartView_Previews : PreviewProvider {
    static var previews: some View {
        StartView(presenter: StartPresenter())
    }
}
#endif
