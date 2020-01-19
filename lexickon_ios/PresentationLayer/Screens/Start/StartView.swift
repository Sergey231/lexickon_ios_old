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
    
    private var createAccountButton: some View {
        return NavigationLink(
            destination: DI.share.assembler.resolver.resolve(RegistrationView.self)) {
                Text(Localized.startCreateAccountButtonTitle).fontWeight(.bold)
        }
        .buttonStyle(LXFilledButtonStyle())
    }
    
    private var iHaveAccountButton: some View {
        return NavigationLink(
        destination: DI.share.assembler.resolver.resolve(LoginView.self)) {
            Text(Localized.startIHaveAccountButtonTitle).fontWeight(.bold)
        }
        .buttonStyle(LXFilledButtonStyle())
    }
    
    private var beginButton: some View {
        return NavigationLink(
        destination: Text(Localized.startBeginButtonTitle)) {
            Text(Localized.startBeginButtonTitle).fontWeight(.bold)
        }
        .buttonStyle(LXRoundedWhiteButtonStyle())
        .padding(.bottom, Constants.Margin.regular)
    }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
                
                LXStartLogo()
                
                VStack {
                    Spacer()
                    createAccountButton
                    iHaveAccountButton
                    beginButton
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
