//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 16.08.2021.
//

import UIKit

extension UIView {
    public func frameOfViewInWindowsCoordinateSystem(to view: UIView? = nil) -> CGRect {
        if let superview = superview {
            return superview.convert(frame, to: view)
        }
        print("[ANIMATION WARNING] Seems like this view is not in views hierarchy\n\(self)\nOriginal frame returned")
        return frame
    }
}
