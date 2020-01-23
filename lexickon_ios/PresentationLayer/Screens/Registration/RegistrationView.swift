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
            Text("ss")
        }
    }
    
    private var nameTextField: some View {
        return TextField(
            Localized.registrationNameTextfield,
            text: $presenter.name
        )
    }
    
    private var emialTextField: some View {
        return TextField(
            Localized.registrationEmailTextfield,
            text: $presenter.email
        )
    }
    
    private var passwordTextField: some View {
        return SecureField(
            Localized.registrationPasswordTextfield,
            text: $presenter.password
        )
    }
    
    private var submitButton: some View {
        return NavigationLink(
            Localized.registrationCreateAccountTitle,
            destination: Text("In App")
        ).disabled(!presenter.canSubmit)
            .buttonStyle(LXRoundedWhiteButtonStyle(disabled: !presenter.canSubmit))
        .padding([.top, .bottom], 16)
    }
    
    var body: some View {
        
        ZStack {
            
            Color.green.edgesIgnoringSafeArea(.all)
            
            VStack {
                self.nameTextField
                self.emialTextField
                self.passwordTextField
                self.submitButton
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
