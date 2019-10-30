//
//ColorExtensions.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 9/27/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import SwiftUI

extension String {
    
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        
        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = count

        guard Scanner(string: self).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }
        
        return (
            red: r,
            green: g,
            blue: b,
            alpha: a
        )
    }
}
