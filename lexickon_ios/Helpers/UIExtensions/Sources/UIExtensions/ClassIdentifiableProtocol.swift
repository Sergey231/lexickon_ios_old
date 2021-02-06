//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 04.11.2020.
//

public protocol ClassIdentifiable: class {
    static var reuseId: String { get }
}

public extension ClassIdentifiable {
    static var reuseId: String {
        return String(describing: self)
    }
}
