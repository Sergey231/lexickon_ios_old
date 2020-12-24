//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 18.12.2020.
//

import Foundation

extension Array {
    
    public func item(at index: Int) -> Element? {
        guard indices.contains(index) else {
            return nil
        }
        return self[index]
    }
    
    public mutating func remove(where: (Element) -> Bool) -> Element? {
        if let index = self.firstIndex(where: `where`) {
            return remove(at: Int(index))
        }
        return nil
    }
    
    public func appending(_ item: Element) -> Array<Element> {
        var array = self
        array.append(item)
        return array
    }
    
    public func removing(at index: Int) -> Array<Element> {
        var array = self
        array.remove(at: index)
        return array
    }
    
    public func appending(if condition: Bool, _ itemFactory: () -> Element) -> Array<Element> {
        guard condition else { return self }
        
        return appending(itemFactory())
    }
    
    public func appending(if condition: Bool, _ collectionFactory: () -> Array<Element>) -> Array<Element> {
        guard condition else { return self }
        
        return appending(contentsOf: collectionFactory())
    }
    
    /// - Note: Replaces nothing when index is out of bounds.
    public func replacingItem(at index: Int, with item: Element) -> Array<Element> {
        return self
            .enumerated()
            .map { $0 == index ? item : $1 }
    }

    public func appending(contentsOf otherArray: [Element]) -> [Element] {
        var array = self
        array.append(contentsOf: otherArray)
        return array
    }
    
    public func appending<C: Collection>(contentsOf collection: C) -> [Element] where C.Element == Element {
        var array = self
        array.append(contentsOf: collection)
        return array
    }
    
    public func lastItemIndicated() -> Array<(Bool, Element)> {
        return enumerated().map { (offset, element) in
            (offset == count - 1, element)
        }
    }
    
    public func findFirstMatchingAndSwapIfNeeded(condition: @escaping (Element) -> Bool) -> [Element] {
        guard let first = first, !condition(first) else { return self }
        guard let availableIndex = firstIndex(where: condition) else { return self }
        var array = self
        array.swapAt(0, availableIndex)
        return array
    }
    
    public init(_ count: Int, generator: @escaping() -> Element) {
        guard count > 0 else {
            self.init()
            return
        }
        self.init((0..<count).lazy.map { Element in generator() })
    }
}
