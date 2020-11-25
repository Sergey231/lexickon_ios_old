//
//  HomeHeaderView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 02.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class HomeHeaderView: UIView {
    
    struct Input {
        var icon: UIImage?
    }
    
    struct Output {
        let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.pin.all()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubview(
            button
        )
    }
    
    private func configureUI() {
        backgroundColor = .purple
    }
    
    func configure(input: Input) -> Output {
        return Output(didTap: button.rx.tap.asSignal())
    }
}
