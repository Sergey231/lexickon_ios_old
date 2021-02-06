//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 30.11.2020.
//

import UIKit

extension UIView {
    
    public var globalPoint: CGPoint? {
        return self.superview?.convert(self.frame.origin, to: nil)
    }

    public var globalFrame: CGRect? {
        return self.superview?.convert(self.frame, to: nil)
    }
}
