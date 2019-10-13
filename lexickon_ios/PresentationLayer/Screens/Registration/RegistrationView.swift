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
    
    @State private var nameValue: String = ""
    @State private var emailValue: String = ""
    
//    private var scrollView: some View {
//        
//        
//    }
    
    private var nameTextField: some View {
        
        let input = LXTextField.Input(
            value: $nameValue,
            placeholder: Localized.registrationNameTextfield,
            icon: Asset.Images.accountOutline,
            tintColor: .white
        )
        
        return LXTextField(input: input)
    }
    
    private var emialTextField: some View {
        
        let input = LXTextField.Input(
            value: $emailValue,
            placeholder: Localized.registrationEmailTextfield,
            icon: Asset.Images.emailIcon,
            tintColor: .white
        )
        
        return LXTextField(input: input)
    }
    
    var body: some View {
        
        ZStack {
            
            Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        self.nameTextField.padding(.horizontal, 40)
                        self.emialTextField.padding(.horizontal, 40)
                    }.frame(height: geometry.size.height)
                }
            }
        }
            
        .statusBar(hidden: true)
        .navigationBarTitle(Localized.registrationCreateAccountTitle)
    }
}

#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
#endif
