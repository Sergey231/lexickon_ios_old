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
        systemFont(ofSize: size, weight: .regular)
    }
    
    public static var regular24: UIFont {
        systemRegular(of: 24)
    }
    
    public static var regular17: UIFont {
        systemRegular(of: 17)
    }
    
    public static var regular14: UIFont {
        systemRegular(of: 14)
    }
    
    public static var regular12: UIFont {
        systemRegular(of: 12)
    }
    
    // MARK: - Bold
    public static func systemBold(of size: CGFloat) -> UIFont {
        systemFont(ofSize: size, weight: .bold)
    }
    
    public static var bold18: UIFont {
        systemBold(of: 18)
    }
}
