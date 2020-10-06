//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 11.02.2020.
//

import UIKit

extension UIViewController {
    
    public func configureHidingKeyboardByTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(Self.myviewTapped(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func myviewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
