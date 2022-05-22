//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 20.06.2021.
//

import UIKit
import UIExtensions
import SnapKit
import RxCocoa
import RxSwift

public final class SpeekerButton: UIButton {
    
    public struct Output {
        public let didTap: Signal<Void>
    }
    
    private let desposeBag = DisposeBag()
    
    fileprivate let speekerImageView = UIImageView()
    fileprivate let button = UIButton()
    
    required init(value: Int = 0) {
        super.init(frame: .zero)
        self.createUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createUI() {
        
        snp.makeConstraints {
            $0.size.equalTo(Size.icon)
        }
        
        speekerImageView.setup {
            $0.tintColor = .lightGray
            $0.image = Images.speekerIcon.image
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(32)
                $0.center.equalToSuperview()
            }
        }
        
        button.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure() -> Output {
        Output(didTap: button.rx.tap.asSignal())
    }
}

private extension Reactive where Base: MoreButton {
    
}

