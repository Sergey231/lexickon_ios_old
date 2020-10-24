//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 24.10.2020.
//

import UIKit

extension UIImage {
    public func width(withHeight: CGFloat) -> CGFloat {
        let aspect = size.width / size.height
        return withHeight * aspect
    }
}
