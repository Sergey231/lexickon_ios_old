//
//  UIView+AddSubviews.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

extension UIView {

    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
    }

    public func addSubviews(_ subviews: [UIView]) {
        subviews.forEach(addSubview)
    }
    
    public func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
