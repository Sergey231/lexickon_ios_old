//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 18.12.2020.
//

import Foundation

extension Array where Element: Hashable {
    public func containsAllElementsOf(_ array: [Element]) -> Bool {
        let selfSet = Set(self)
        let secondArraySet = Set(array)
        return selfSet.isSuperset(of: secondArraySet)
    }
}
