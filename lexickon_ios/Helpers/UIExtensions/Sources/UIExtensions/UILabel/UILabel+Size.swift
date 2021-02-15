//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 15.02.2021.
//

import UIKit

public extension UIFont {
    
    func width(height: CGFloat) -> CGFloat {

        let rect = CGSize(
            width: .greatestFiniteMagnitude,
            height: height
        )

        let boundingBox = self.text.boundingRect(
            with: rect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: self.font],
            context: nil
        )

        return boundingBox.width
    }
}

