//
//  StartLogo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 31.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import PinLayout
import Combine

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
        
        var eyesSize: CGFloat {
            switch self {
            case .start: return 14
            case .end: return 10
            }
        }
        
        var eyesVCenter: CGFloat {
            switch self {
            case .start: return 34
            case .end: return 26
            }
        }
        
        var leftEyeHCenter: CGFloat {
            switch self {
            case .start: return -9
            case .end: return -7
            }
        }
        
        var rightEyeHCenter: CGFloat {
            switch self {
            case .start: return 13
            case .end: return 9
            }
        }
    }
    
    private let logoImageView = UIImageView()
    private let textLogoImageView = UIImageView()
    private var animationState: AnimationState = .start
    private let leftEyeView = UIView()
    private let rightEyeView = UIView()

    private var cancellableSet = Set<AnyCancellable>()
    private let timePublisher = Timer.TimerPublisher(
        interval: 1.0,
        runLoop: .main,
        mode: .default
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    func startAnimation(complete: (() -> ())? = nil) {
        animationState = .end
        
        UIView.animate(withDuration: 1, animations: {
            self.layout()
        }, completion: { _ in
            
            self.logoImageView.startFlayingAnimation()
            
            UIView.animate(withDuration: 1, animations: {
                self.textLogoImageView.alpha = self.animationState.textLogoAlpha
            }, completion: { _ in
                if let _complete = complete {
                    _complete()
                }
            })
        })
    }
    
    func stopAnimation() {
        animationState = .start
        logoImageView.stopFlayingAnimation()
    }
    
    private func eyesFlipAnimate() {
        leftEyeView.performVCollapseAnimation()
        rightEyeView.performVCollapseAnimation()
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
        
        leftEyeView.pin
            .size(animationState.eyesSize)
            .hCenter(animationState.leftEyeHCenter)
            .vCenter(animationState.eyesVCenter)
        
        rightEyeView.pin
            .size(animationState.eyesSize)
            .hCenter(animationState.rightEyeHCenter)
            .vCenter(animationState.eyesVCenter)
        
        leftEyeView.round()
        rightEyeView.round()
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
        
        logoImageView.addSubviews(
            leftEyeView,
            rightEyeView
        )
    }
    
    private func configureUI() {
        
        setShadow()
        
        backgroundColor = .gray
        logoImageView.image = Asset.Images.logoWithoutEyes.image
        logoImageView.contentMode = .scaleAspectFit
        textLogoImageView.image = Asset.Images.textLogo.image
        textLogoImageView.contentMode = .scaleAspectFit
        textLogoImageView.alpha = animationState.textLogoAlpha
        
        // Eyes
        leftEyeView.backgroundColor = .white
        rightEyeView.backgroundColor = .white
        
        timePublisher
            .map { _ in Int.random(in: Range<Int>(uncheckedBounds: (lower: 0, upper: 4))) }
            .filter { $0 == 0 }
            .sink { _ in self.eyesFlipAnimate() }
            .store(in: &cancellableSet)
        
        timePublisher
            .connect()
            .store(in: &cancellableSet)
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
