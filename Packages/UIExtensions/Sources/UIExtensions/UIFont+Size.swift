//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 16.11.2020.
//

import UIKit

extension UIFont {
    
    // MARK: - Regular
    public static func systemRegular(of size: CGFloat) -> UIFont {
        return systemFont(ofSize: size, weight: .regular)
    }
    
    public static var systemRegular24: UIFont {
        return .systemRegular(of: 24)
    }
    
    public static var systemRegular17: UIFont {
        return .systemRegular(of: 17)
    }
    
    public static var systemRegular12: UIFont {
        return .systemRegular(of: 12)
    }
}
