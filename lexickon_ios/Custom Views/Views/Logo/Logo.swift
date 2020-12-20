//
//  Logo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import Combine

final class Logo: UIView {
    
    struct Input {
        let tintColor: UIColor
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Asset.Images.logoWithoutEyes.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
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
        
        logoImageView.snp.makeConstraints {
            $0.size.equalTo(45)
            $0.center.equalToSuperview()
        }
        
        leftEyeView.snp.makeConstraints {
            $0.size.equalTo(5)
            $0.centerX.equalToSuperview().offset(-3)
            $0.centerY.equalToSuperview().offset(12)
        }

        rightEyeView.snp.makeConstraints {
            $0.size.equalTo(5)
            $0.centerX.equalToSuperview().offset(4)
            $0.centerY.equalToSuperview().offset(12)
        }
    }
    
    private func eyesFlipAnimate() {
        leftEyeView.performVCollapseAnimation()
        rightEyeView.performVCollapseAnimation()
    }
    
    private func configureUI() {
    
        timePublisher
            .map { _ in Int.random(in: Range<Int>(uncheckedBounds: (lower: 0, upper: 4))) }
            .filter { $0 == 0 }
            .sink { _ in self.eyesFlipAnimate() }
            .store(in: &cancellableSet)
        
        timePublisher
            .connect()
            .store(in: &cancellableSet)
    }
    
    func configure(with input: Input) {
        logoImageView.tintColor = input.tintColor
        leftEyeView.backgroundColor = input.tintColor
        rightEyeView.backgroundColor = input.tintColor
        leftEyeView.round()
        rightEyeView.round()
    }
}
