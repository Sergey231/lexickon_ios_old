//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 12.02.2020.
//

import UIKit

extension UINavigationController {
    
    public func setupLargeMainThemeNavBar() {
        
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .white
        
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor : UIColor.white
            ]
        }
    }
}
