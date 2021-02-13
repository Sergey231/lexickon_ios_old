//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 16.01.2021.
//

import UIKit
import UIExtensions
import Assets
import SnapKit
import RxCocoa
import RxSwift

public final class AddWordButton: UIButton {
    
    private let desposeBag = DisposeBag()
    
    private let addIconImageView = UIImageView(image: Asset.Images.searchIcon.image)
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
        self.createUI()
        self.configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        backgroundColor = Asset.Colors.mainBG.color
        
        addIconImageView.setup {
            $0.tintColor = .white
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(Size.icon)
                $0.center.equalToSuperview()
            }
        }
        
        rx.size
            .asDriver(onErrorDriveWith: .empty())
            .map { $0.height/2 }
            .drive(rx.cornerRadius)
            .disposed(by: desposeBag)
    }
    
    private func configure() {
        
    }
}

private extension Reactive where Base: AddWordButton {
    var cornerRadius: Binder<CGFloat> {
        Binder(base) { base, cornerRadius in
            base.layer.cornerRadius = cornerRadius
        }
    }
}
