//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 18.12.2020.
//

import Foundation

extension Array {
    
    /// Убирает из массива элементы с одинаковым параметром
    public func unique<T: Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}
