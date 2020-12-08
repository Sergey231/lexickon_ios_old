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
    private let label = UILabel()
    
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
            .hCenter()
            .top()
        
        label.pin
            .below(of: logoView)
            .horizontally()
            .bottom()
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            logoView,
            label
        )
    }
    
    private func configureUI() {
        logoView.configure(with: .init(tintColor: .lightGray))
        logoView.startFlayingAnimation()
        label.textAlignment = .center
        label.text = L10n.newWrodPlaceholder
        label.numberOfLines = 0
        label.textColor = .lightGray
    }
    
    func stopFlaying() {
        logoView.stopFlayingAnimation()
    }
}

