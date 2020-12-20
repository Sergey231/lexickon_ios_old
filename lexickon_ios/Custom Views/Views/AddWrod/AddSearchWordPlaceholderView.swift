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
    
    private let logoView: Logo = {
        let view = Logo()
        view.startFlayingAnimation()
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = L10n.newWrodPlaceholder
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        addSubviews(
            logoView,
            label
        )
        
        logoView.configure(with: .init(tintColor: .lightGray))
        
        logoView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(logoView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func stopFlaying() {
        logoView.stopFlayingAnimation()
    }
}

