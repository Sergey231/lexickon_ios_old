//
//  ButtonControl.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 5/28/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout

final class ButtonControl: UIButton {
    
    private var title = UILabel()
    private let style: Style = .normal(tintColor: .white)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(
        frame: CGRect = .zero,
        text: String,
        style: Style = .normal(tintColor: .white)
        ) {
        
        self.init(frame: frame)
        addSubview(title)
        setStyle(style, text: text)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.pin.all()
        layer.cornerRadius = frame.size.height/2
    }
    
    private func setStyle( _ style: Style, text: String) {
        
        backgroundColor = style.backgroundColor
        layer.borderColor = style.tintColor.cgColor
        title.text = text
        title.textColor = style.textColor
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 15)
        layer.borderWidth = 2
    }
    
    struct Constants {
        static let width: CGFloat = 280
        static let height: CGFloat = 48
    }
}

extension ButtonControl {
    
    enum Style {
        
        case normal(tintColor: UIColor)
        case filled(tintColor: UIColor, textColor: UIColor)
        
        var backgroundColor: UIColor {
            switch self {
            case .normal: return UIColor.clear
            case .filled(let tintColor, _): return tintColor
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .normal(let tintColor): return tintColor
            case .filled(let tintColor, _): return tintColor
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .normal(let tintColor): return tintColor
            case .filled(_, let textColor): return textColor
            }
        }
    }
}
