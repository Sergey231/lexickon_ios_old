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
        
        NavigationView {
            
            ZStack {
                
                Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
                
                StartLogoView()
                
                VStack {
                    
                    Spacer()
                    
                    NavigationLinkView(
                        destination: Text(Localizable.createAccount),
                        title: Localizable.createAccount,
                        style: .filled(
                            bgColor: .white,
                            labelColor: Asset.Colors.mainBG)
                    ).padding(Constants.Margin.small)
                    
                    NavigationLinkView(
                        destination: Text(Localizable.iHaveAccountButtonTitle),
                        title: Localizable.iHaveAccountButtonTitle,
                        style: .filled(
                            bgColor: .white,
                            labelColor: Asset.Colors.mainBG)
                    ).padding(Constants.Margin.small)
                    
                    NavigationLinkView(
                        destination: Text(Localizable.begin),
                        title: Localizable.begin,
                        style: .normal(tintColor: Color.white)
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
