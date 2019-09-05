//
//  RgistrationPresenterView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    
    init() {
        
        // for navigation bar large title color
        UINavigationBar.appearance()
            .largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // for navigation bar title color
        UINavigationBar.appearance()
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.red]
        
        UINavigationBar.appearance().showsLargeContentViewer = false
    }
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                Asset.Colors.mainBG.edgesIgnoringSafeArea(.all)
                
                VStack {
                    
                    Spacer()
                    
                    NavigationLink(destination: Text("1")) {
                        
                        Text("tttt")
                        
//                        ButtonView(
//                            title: "Создать",
//                            style: .filled(
//                                bgColor: .white,
//                                labelColor: Asset.Colors.mainBG)
//                        ).padding(Constants.Margin.small)
                    }
                    .navigationBarTitle(
                        Text("Создать аккаут")
                    )
                    
                }
            }
            
        }
    }
}

#if DEBUG
struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
#endif
