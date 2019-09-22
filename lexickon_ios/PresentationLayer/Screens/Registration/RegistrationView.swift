//
//  RgistrationPresenterView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init() {
        
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
    
    @State private var nameTextFieldValue: String = ""
    @State private var emailTextFieldValue: String = ""
    
    private var nameTextField: TextFieldView {
        TextFieldView(
            value: $nameTextFieldValue,
            placeholder: Localizable.registrationNameTextfield,
            icon: Asset.Images.accountOutline,
            tintColor: .white
        )
    }
    
    private var mailTextField: TextFieldView {
        TextFieldView(
            value: $emailTextFieldValue,
            placeholder: Localizable.registrationEmailTextfield,
            icon: Asset.Images.emailIcon,
            tintColor: .white
        )
    }
    
    var body: some View {
            
        ZStack {
            
            Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
            
            VStack {
                nameTextField.padding(.horizontal, 40)
                mailTextField.padding(.horizontal, 40)
            }
        }
            
        .statusBar(hidden: true)
        .navigationBarTitle(Localizable.registrationCreateAccountTitle)
    }
}

#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
#endif
