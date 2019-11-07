//
//  RgistrationPresenterView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI
import Combine

struct RegistrationView: View {
    
    @ObservedObject var presenter: RegistrationPresenter
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(presenter: RegistrationPresenter) {
        
        self.presenter = presenter
        
        // for navigation bar large title color
        UINavigationBar.appearance()
            .largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // for navigation bar title color
        UINavigationBar.appearance()
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // for navigation bar items
        UINavigationBar.appearance()
            .tintColor = .white
        
        UINavigationBar.appearance().showsLargeContentViewer = false
    }
    
    var btnBack : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Asset.Images.backArrow
                .foregroundColor(.white)
                .aspectRatio(contentMode: .fit)
        }
    }
    
    private var nameTextField: some View {
        return TextField(
            Localized.registrationNameTextfield,
            text: $presenter.name
        ).modifier(LXTextFieldStyle(leftIcon: Asset.Images.accountIcon))
    }
    
    private var emialTextField: some View {
        return TextField(
            Localized.registrationEmailTextfield,
            text: $presenter.email
        ).modifier(LXTextFieldStyle(leftIcon: Asset.Images.emailIcon))
    }
    
    private var passwordTextField: some View {
        return SecureField(
            Localized.registrationPasswordTextfield,
            text: $presenter.password
        ).modifier(LXTextFieldStyle(leftIcon: Asset.Images.lockIcon))
    }
    
    var body: some View {
        
        ZStack {
            
            Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(presenter.isValid ? "valid" : "not valid")
                self.nameTextField
                self.emialTextField
                self.passwordTextField
            }.offset(
                x: 0,
                y: self.presenter.keyboardHeight/(-2)
            ).animation(Animation.default.speed(1.3))
        }
            
        .statusBar(hidden: true)
        .navigationBarTitle(Localized.registrationCreateAccountTitle)
        
    }
}


#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(presenter: DI.share.assembler.resolver.resolve(RegistrationPresenter.self)!)
    }
}
#endif
