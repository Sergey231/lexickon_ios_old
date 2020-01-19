//
//  LoginView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 30.11.2019.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI
import Combine

struct LoginView: View {

    @ObservedObject var presenter: LoginPresenter
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    private var cancellableSet: Set<AnyCancellable> = []

    init(presenter: LoginPresenter) {

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
    
    private var submitButton: some View {
        return NavigationLink(
            Localized.loginLoginButtonTitle,
            destination: Text("In App")
        ).disabled(!presenter.canSubmit)
            .buttonStyle(LXRoundedWhiteButtonStyle(disabled: !presenter.canSubmit))
        .padding([.top, .bottom], 16)
    }
    
    var body: some View {
        
        ZStack {
            
            Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
            
            VStack {
                self.emialTextField
                self.passwordTextField
                self.submitButton
            }.offset(
                x: 0,
                y: self.presenter.keyboardHeight/(-2)
            ).animation(Animation.default.speed(1.3))
            
            .statusBar(hidden: true)
            .navigationBarTitle(Localized.loginScreenTitle)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(presenter: LoginPresenter())
    }
}
#endif
