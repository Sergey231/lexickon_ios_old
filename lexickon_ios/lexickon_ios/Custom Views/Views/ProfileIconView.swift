//
//  IconButtonView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class ProfileIconView: UIView {
    
    struct Input {
        var icon: UIImage?
    }
    
    struct Output {
        let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        iconImageView.pin.all()
        
        let buttonSize = frame.size.height < 50
            ? 50
            : frame.size.height
        
        button.pin
            .center()
            .size(buttonSize)
        
        layer.cornerRadius = frame.size.height/2
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            iconImageView,
            button
        )
    }
    
    private func configureUI() {
        iconImageView.contentMode = .scaleAspectFit
    }
    
    func configure(input: Input) -> Output {
        iconImageView.image = input.icon
        return Output(didTap: button.rx.tap.asSignal())
    }
}

