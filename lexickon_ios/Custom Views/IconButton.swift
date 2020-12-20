//
//  IconButton.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 18.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class SwitchIconButton: UIView {
    
    struct Input {
        let icon: Driver<UIImage>
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    private let iconImageView = UIImageView()
    
    var didTap: Signal<Void> {
        button.rx.tap.asSignal()
    }
    
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
        iconImageView.pin.all()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(iconImageView, button)
    }
    
    private func configureUI() {
        iconImageView.contentMode = .scaleAspectFit
    }
    
    func configure(input: Input) {
        input.icon
            .drive(iconImageView.rx.imageWithAnimation)
            .disposed(by: disposeBag)
    }
}
