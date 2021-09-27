//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 18.12.2020.
//

import UIKit

public enum Margin {
    public static let small: CGFloat = 8
    public static let regular: CGFloat = 16
    public static let mid: CGFloat = 24
    public static let big: CGFloat = 32
    public static let huge: CGFloat = 56
}

public enum CornerRadius {
    public static let regular: CGFloat = 8
    public static let big: CGFloat = 16
}

public enum Size {
    public static let button = CGSize(width: 280, height: 48)
    public static let icon = CGSize(width: 24, height: 24)
    public static let uiTextField = CGSize(width: 260, height: 44)
    public static let textField = CGSize(width: 260, height: 48)
    public static let line = CGSize(width: 260, height: 2)
    public static let activityIndicator = CGSize(width: 36, height: 36)
}
