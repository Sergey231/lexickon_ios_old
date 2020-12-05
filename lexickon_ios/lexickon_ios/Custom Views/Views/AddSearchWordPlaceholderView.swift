//
//  AddSearchWordPlaceholderView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 05.12.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

final class AddSearchPlaceholderView: UIView {
    
    private let disposeBag = DisposeBag()
    
    private let logoView = Logo()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoView.pin
            .size(72)
            .hCenter()
            .top()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            logoView
        )
    }
    
    private func configureUI() {
        backgroundColor = .lightGray
        logoView.configure(with: .init(tintColor: .gray))
        logoView.startFlayingAnimation()
    }
    
    func stopFlaying() {
        logoView.stopFlayingAnimation()
    }
}

