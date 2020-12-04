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
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func configureView() {
        createUI()
        configureUI()
    }
       
    private func createUI() {
        addSubviews(
            
        )
    }
    
    private func configureUI() {
        backgroundColor = Asset.Colors.mainBG.color
    }
}
