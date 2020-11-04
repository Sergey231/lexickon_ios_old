//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 04.11.2020.
//

import UIKit

public extension UIView {
    public func dequeueError<T>(
        withIdentifier reuseIdentifier: String,
        type _: T
    ) -> String {
        return "Couldn't dequeue \(T.self) with identifier \(reuseIdentifier)"
    }
}
