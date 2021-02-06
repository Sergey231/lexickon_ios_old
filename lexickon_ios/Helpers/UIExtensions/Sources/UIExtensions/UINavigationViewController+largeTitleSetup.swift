//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 22.12.2020.
//

import UIKit

extension UINavigationController {
    
    public func setupLargeTitleNavBar(
        bgColor: UIColor = .white,
        navBarItemsColor: UIColor = .white,
        largeTitleColor: UIColor = .white
    ) {
        
        navigationBar.barTintColor = bgColor
        navigationBar.tintColor = navBarItemsColor
        
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationBar.largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor : largeTitleColor
            ]
        }
    }
}
