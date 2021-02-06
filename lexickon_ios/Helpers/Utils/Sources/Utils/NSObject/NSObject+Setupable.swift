//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 11.01.2021.
//

import Foundation

extension NSObject: Setupable {}

public protocol Setupable {}

extension Setupable {
    
    @discardableResult
    public func setup(closure: ((Self) -> Void)) -> Self {
        closure(self)
        return self
    }
}
