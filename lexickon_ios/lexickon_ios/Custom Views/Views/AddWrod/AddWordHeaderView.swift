//
//  AddWordHeaderView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 29.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class AddWordHeaderView: UIView {
    
    struct Output {
        let backButtonDidTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    let backButton = UIButton()
    private let textView = AddSearchWordTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backButton.pin
            .top(pin.safeArea.top)
            .left()
            .size(56)
        
        textView.pin
            .below(of: backButton)
            .horizontally(Margin.mid)
            .bottom(Margin.regular)
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            textView,
            backButton
        )
    }
    
    private func configureUI() {
        backgroundColor = Asset.Colors.mainBG.color
        backButton.setImage(Asset.Images.backArrow.image, for: .normal)
        
    }
    
    func configure() -> Output {
        textView.configure()
        return Output(backButtonDidTap: backButton.rx.tap.asSignal())
    }
}
