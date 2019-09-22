//
//  StartView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI
import Swinject

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
                        destination: DI.share.assembler.resolver.resolve(RegistrationView.self),
                        title: Localizable.startCreateAccountButtonTitle,
                        style: .filled(
                            bgColor: .white,
                            labelColor: Asset.Colors.mainBG)
                    ).padding(Constants.Margin.small)
                    
                    NavigationLinkView(
                        destination: Text(Localizable.startIHaveAccountButtonTitle),
                        title: Localizable.startIHaveAccountButtonTitle,
                        style: .filled(
                            bgColor: .white,
                            labelColor: Asset.Colors.mainBG)
                    ).padding(Constants.Margin.small)
                    
                    NavigationLinkView(
                        destination: Text(Localizable.startBeginButtonTitle),
                        title: Localizable.startBeginButtonTitle,
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
