//
//  StartLogo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 31.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Combine
import SnapKit
import Assets

public final class StartLogo: UIView {
    
    public init() {
        super.init(frame: .zero)
        configureView()
        setupContstraiots()
    }
    
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
        
        var leftEyeCenterX: CGFloat {
            switch self {
            case .start: return -9
            case .end: return -7
            }
        }
        
        var rightEyeCenterX: CGFloat {
            switch self {
            case .start: return 13
            case .end: return 9
            }
        }
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.logoWithoutEyes.image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let textLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.textLogo.image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let leftEyeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let rightEyeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private var animationState: AnimationState = .start

    private var cancellableSet = Set<AnyCancellable>()
    private let timePublisher = Timer.TimerPublisher(
        interval: 1.0,
        runLoop: .main,
        mode: .default
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupContstraiots()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimation(complete: (() -> ())? = nil) {
        
        animationState = .end
        UIView.animate(withDuration: 1, animations: {
            self._updateConstraints()
            self.layoutIfNeeded()
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
    
    public func stopAnimation() {
        animationState = .start
        logoImageView.stopFlayingAnimation()
    }
    
    private func eyesFlipAnimate() {
        leftEyeView.performVCollapseAnimation()
        rightEyeView.performVCollapseAnimation()
    }

    private func setupContstraiots() {
        
        logoImageView.snp.remakeConstraints {
            $0.height.width.equalTo(animationState.logoSize)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(animationState.logoPosition)
        }
        
        textLogoImageView.snp.remakeConstraints {
            $0.size.equalTo(CGSize(width: 200, height: 80))
            $0.center.equalToSuperview()
        }
        
        leftEyeView.snp.remakeConstraints {
            $0.height.width.equalTo(animationState.eyesSize)
            $0.centerX.equalToSuperview().offset(animationState.leftEyeCenterX)
            $0.centerY.equalToSuperview().offset(animationState.eyesVCenter)
        }
        
        rightEyeView.snp.remakeConstraints {
            $0.height.width.equalTo(animationState.eyesSize)
            $0.centerX.equalToSuperview().offset(animationState.rightEyeCenterX)
            $0.centerY.equalToSuperview().offset(animationState.eyesVCenter)
        }
        
        leftEyeView.round()
        rightEyeView.round()
    }
    
    internal func _updateConstraints() {
        logoImageView.snp.updateConstraints {
            $0.height.width.equalTo(animationState.logoSize)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(animationState.logoPosition)
        }
        
        leftEyeView.snp.updateConstraints {
            $0.height.width.equalTo(animationState.eyesSize)
            $0.centerX.equalToSuperview().offset(animationState.leftEyeCenterX)
            $0.centerY.equalToSuperview().offset(animationState.eyesVCenter)
        }
        
        rightEyeView.snp.updateConstraints {
            $0.height.width.equalTo(animationState.eyesSize)
            $0.centerX.equalToSuperview().offset(animationState.rightEyeCenterX)
            $0.centerY.equalToSuperview().offset(animationState.eyesVCenter)
        }
        
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
        textLogoImageView.alpha = animationState.textLogoAlpha
        
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
