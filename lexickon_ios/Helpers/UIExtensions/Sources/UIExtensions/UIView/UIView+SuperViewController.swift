//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 20.06.2021.
//

import UIKit

extension UIResponder {
    public var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
