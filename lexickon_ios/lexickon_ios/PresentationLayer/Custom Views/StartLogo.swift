//
//  StartLogo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 31.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI

final class StartLogo: UIView {
    
    private enum AnimationState {
        case start
        case end
        
        var logoSize: CGFloat {
            switch self {
            case .start: return 141
            case .end: return 100
            }
        }
        
        var logoPosition: CGFloat {
            switch self {
            case .start: return 0
            case .end: return -100
            }
        }
        
        var textLogoAlpha: CGFloat {
            switch self {
            case .start: return 0
            case .end: return 1
            }
        }
    }
    
    private let logoImageView = UIImageView()
    private let textLogoImageView = UIImageView()
    private var animationState: AnimationState = .start
    
    //MARK: init programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    //MAEK: init from XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func startAnimation() {
        animationState = .end
        UIView.animate(withDuration: 1, animations: {
            self.layout()
        }, completion: { _ in
            UIView.animate(withDuration: 1) {
                self.textLogoImageView.alpha = self.animationState.textLogoAlpha
            }
        })
    }

    private func layout() {
        logoImageView.pin
            .size(animationState.logoSize)
            .hCenter()
            .vCenter(animationState.logoPosition)
        
        textLogoImageView.pin
            .center()
            .height(80)
            .width(200)
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
    
    private func createUI() {
        addSubviews(
            logoImageView,
            textLogoImageView
        )
    }
    
    private func configureUI() {
        backgroundColor = .gray
        logoImageView.image = Asset.Images.logoWithoutEyes.image
        logoImageView.contentMode = .scaleAspectFit
        textLogoImageView.image = Asset.Images.textLogo.image
        textLogoImageView.contentMode = .scaleAspectFit
        textLogoImageView.alpha = animationState.textLogoAlpha
    }
}

extension StartLogo: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return StartLogo()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct StartLogo_Preview: PreviewProvider {
    static var previews: some View {
        StartLogo()
    }
}
