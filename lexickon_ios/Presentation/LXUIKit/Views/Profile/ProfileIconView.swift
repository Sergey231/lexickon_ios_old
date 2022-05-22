//
//  IconButtonView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 25.10.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import UIExtensions
import RxExtensions

public final class ProfileIconView: UIView {
    
    private enum UIConstants {
        static let buttonSize: CGFloat = 44
    }
    
    public struct Input {
        let icon: UIImage?
        let isEditMode: Driver<Bool>
        public init(
            icon: UIImage? = nil,
            isEditMode: Driver<Bool>
        ) {
            self.icon = icon
            self.isEditMode = isEditMode
        }
    }
    
    public struct Output {
        public let didTap: Signal<Void>
        public let didTapOnRemoveAva: Signal<Void>
        public let didTapOnEditAva: Signal<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let button = UIButton()
    fileprivate let iconImageView = UIImageView()
    fileprivate let editAvaButton = UIButton()
    fileprivate let removeAvaButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
       
    private func createUI() {
        
        iconImageView.setup {
            $0.contentMode = .scaleAspectFit
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        editAvaButton.setup {
            $0.layer.cornerRadius = UIConstants.buttonSize/2
            $0.backgroundColor = Colors.mainBG.color
            $0.setImage(Images.Profile.editIcon.image, for: .normal)
            $0.alpha = 0
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.buttonSize)
                $0.center.equalTo(iconImageView.snp.center)
            }
        }
        
        removeAvaButton.setup {
            $0.layer.cornerRadius = UIConstants.buttonSize/2
            $0.backgroundColor = Colors.mainBG.color
            $0.setImage(Images.closeIcon.image, for: .normal)
            $0.alpha = 0
            addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.buttonSize)
                $0.center.equalTo(iconImageView.snp.center)
            }
        }
        
        button.setup {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
    }
    
    public func configure(input: Input) -> Output {
        
        iconImageView.image = input.icon
        
        rx.size.take(1)
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { _ in
                self.layer.cornerRadius = self.frame.size.height/2
            })
            .disposed(by: disposeBag)
        
        input.isEditMode
            .drive(rx.isEditMode)
            .disposed(by: disposeBag)
        
        return Output(
            didTap: button.rx.tap.asSignal(),
            didTapOnRemoveAva: removeAvaButton.rx.tap.asSignal(),
            didTapOnEditAva: editAvaButton.rx.tap.asSignal()
        )
    }
}

private extension Reactive where Base: ProfileIconView {
    
    var isEditMode: Binder<Bool> {
        Binder(base) { base, isEditMode in
            UIView.animate(withDuration: 0.3) {
                base.editAvaButton.alpha = isEditMode ? 1 : 0
                base.removeAvaButton.alpha = isEditMode ? 1 : 0
                let editAvaButtonOffset = isEditMode ? 80 : 0
                let removeAvaButtonOffset = isEditMode ? 130 : 0
                
                base.editAvaButton.snp.updateConstraints {
                    $0.centerX.equalTo(base.iconImageView.snp.centerX).offset(editAvaButtonOffset)
                }
                
                base.removeAvaButton.snp.updateConstraints {
                    $0.centerX.equalTo(base.iconImageView.snp.centerX).offset(removeAvaButtonOffset)
                }
                base.layoutIfNeeded()
            }
        }
    }
}
