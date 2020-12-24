//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 18.12.2020.
//

import Foundation

extension Array {
    /// Сливает несколько массивов в одну коллекцию указанного типа,
    /// фильтруя объекты с неподходящим типом
    public func merge<T>(_ arrays: [T?]..., to type: T.Type) -> [T] {
        return arrays.flatMap { $0.compactMap { $0 } }
    }
}
