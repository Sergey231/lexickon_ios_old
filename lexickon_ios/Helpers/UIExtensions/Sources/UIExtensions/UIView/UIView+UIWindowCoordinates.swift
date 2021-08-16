//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 16.08.2021.
//

import UIKit

extension UIView {
    public func frameOfViewInWindowsCoordinateSystem(_ view: UIView) -> CGRect {
        if let superview = view.superview {
            return superview.convert(view.frame, to: nil)
        }
        print("[ANIMATION WARNING] Seems like this view is not in views hierarchy\n\(view)\nOriginal frame returned")
        return view.frame
    }
}
