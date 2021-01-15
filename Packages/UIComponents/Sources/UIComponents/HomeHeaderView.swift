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
import Assets

public final class HomeHeaderView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        var icon: UIImage?
    }
    
    public struct Output {
        let didTap: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = Asset.Colors.mainBG.color
        
        addSubview(button)
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    public func configure(input: Input) -> Output {
        return Output(didTap: button.rx.tap.asSignal())
    }
}
