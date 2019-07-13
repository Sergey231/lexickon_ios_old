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
        
            Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                StartLogoView()
                Spacer()
                VStack {
                    
                    ButtonView(
                        title: Localizable.createAccount,
                        style: .filled(
                            bgColor: .white,
                            labelColor: Asset.Colors.mainBG)
                    ).padding(Constants.Margin.small)
                    
                    ButtonView(
                        title: Localizable.iHaveAccountButtonTitle,
                        style: .filled(
                            bgColor: .white,
                            labelColor: Asset.Colors.mainBG)
                    ).padding(Constants.Margin.small)
                    
                    ButtonView(
                        title: Localizable.begin,
                        style: .normal(titntColor: Color.white)
                    ).padding(Constants.Margin.small)
                }
            }
            
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
