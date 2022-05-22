//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 30.01.2021.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions

public final class RefreshView: UIView {
    
    public init() {
        super.init(frame: .zero)
        createUI()
    }
    
    public struct Input {
        public init(animateActivity: Driver<Bool>) {
            self.animateActivity = animateActivity
        }
        let animateActivity: Driver<Bool>
    }
    
    private let disposeBag = DisposeBag()
    
    public let refreshImageView = UIImageView()
    public let activityView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        backgroundColor = .clear
        
        refreshImageView.setup {
            $0.image = Images.refresh.image
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .white
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        activityView.setup {
            $0.color = .white
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    public func configure(input: Input) {
        input.animateActivity
            .drive(rx.animation)
            .disposed(by: disposeBag)
    }
}


private extension Reactive where Base: RefreshView {
    var animation: Binder<Bool> {
        Binder(base) { base, animation in
            UIView.animate(withDuration: 0.3) {
                base.refreshImageView.alpha = animation ? 0 : 1
                base.activityView.alpha = animation ? 1 : 0
                if animation {
                    base.activityView.startAnimating()
                } else {
                    base.activityView.stopAnimating()
                }
            }
        }
    }
}
