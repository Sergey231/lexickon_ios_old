//
//  Logo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout
import Combine

final class Logo: UIView {
    
    struct Input {
        let tintColor: UIColor
    }
    
    private let logoImageView = UIImageView()
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
        leftEyeView.round()
        rightEyeView.round()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
    
    private func createUI() {
        addSubview(logoImageView)
        logoImageView.addSubviews(
            leftEyeView,
            rightEyeView
        )
    }
    
    private func eyesFlipAnimate() {
        leftEyeView.performVCollapseAnimation()
        rightEyeView.performVCollapseAnimation()
    }
    
    private func configureUI() {
        
        logoImageView.image = Asset.Images.logoWithoutEyes.image
        logoImageView.contentMode = .scaleAspectFit
        
        timePublisher
            .map { _ in Int.random(in: Range<Int>(uncheckedBounds: (lower: 0, upper: 4))) }
            .filter { $0 == 0 }
            .sink { _ in self.eyesFlipAnimate() }
            .store(in: &cancellableSet)
        
        timePublisher
            .connect()
            .store(in: &cancellableSet)
    }
    
    private func layout() {
        
        logoImageView.pin
            .size(45)
            .hCenter()
            .vCenter()
        
        leftEyeView.pin
            .size(5)
            .hCenter(-3)
            .vCenter(12)
        
        rightEyeView.pin
            .size(5)
            .hCenter(4)
            .vCenter(12)
    }
    
    func configure(with input: Input) {
        logoImageView.tintColor = input.tintColor
        leftEyeView.backgroundColor = input.tintColor
        rightEyeView.backgroundColor = input.tintColor
    }
}
