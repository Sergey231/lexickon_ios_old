//
//  Logo.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.02.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SwiftUI
import PinLayout
import Combine

final class Logo: UIView {
    
    private let logoImageView = UIImageView()
    private let leftEyeView = UIView()
    private let rightEyeView = UIView()
    
    private var cancellableSet = Set<AnyCancellable>()
    private let timePublisher = Timer.TimerPublisher(
        interval: 1.0,
        runLoop: .main,
        mode: .default
    )
    
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
        
        setShadow()
        
        logoImageView.image = Asset.Images.logoWithoutEyes.image
        logoImageView.contentMode = .scaleAspectFit
        
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
        
        logoImageView.startFlayingAnimation()
    }
    
    private func layout() {
        
        logoImageView.pin
            .size(100)
            .hCenter()
            .vCenter()
        
        leftEyeView.pin
            .size(11)
            .hCenter(-7)
            .vCenter(26)
        
        rightEyeView.pin
            .size(11)
            .hCenter(9)
            .vCenter(26)
    }
}


extension Logo: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        return Logo()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct Logo_Previews: PreviewProvider {
    static var previews: some View {
        Logo()
    }
}
