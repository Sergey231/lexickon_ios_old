//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 18.12.2020.
//

import Foundation

extension ArraySlice {
    
    public func item(at index: Int) -> Element? {
        guard index >= 0, count > index else {
            return nil
        }
        return self[index]
    }
}
