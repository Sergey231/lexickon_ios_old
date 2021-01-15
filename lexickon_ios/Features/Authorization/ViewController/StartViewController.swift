//
//  StartView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import RxSwift
import UIComponents
import UIExtensions
import RxExtensions
import Resolver
import Assets

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

class StartViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: StartPresenter
    
    fileprivate let logo = StartLogo()
    
    fileprivate let beginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Str.startBeginButtonTitle, for: .normal)
        return button
    }()
    
    fileprivate let iAmHaveAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle(Str.startIHaveAccountButtonTitle, for: .normal)
        return button
    }()
    
    fileprivate let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle(Str.startCreateAccountButtonTitle, for: .normal)
        return button
    }()
    
    fileprivate let bgImageView: UIImageView = {
        let imageView = UIImageView(image: Asset.Images.bgStart.image)
        imageView.contentMode = .scaleAspectFill
        imageView.alpha = 0
        return imageView
    }()
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("💀")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.mainBG.color
        createUI()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logo.stopAnimation()
    }
    
    private func configureUI() {
        
        navigationController?.setupLargeTitleNavBar()
        
        resetAnimations()

        let presenterInput = StartPresenter.Input(
            beginButtonTapped: beginButton.rx.tap.asSignal(),
            iAmHaveAccountButtonTapped: iAmHaveAccountButton.rx.tap.asSignal(),
            createAccountButtonTapped: createAccountButton.rx.tap.asSignal()
        )
        
        beginButton.setRoundedFilledStyle(titleColor: Asset.Colors.mainBG.color)
        iAmHaveAccountButton.setRoundedBorderedStyle(
            bgColor: Asset.Colors.mainBG.color,
            borderColor: Asset.Colors.mainBG.color
        )
        createAccountButton.setRoundedBorderedStyle(
            bgColor: Asset.Colors.mainBG.color,
            borderColor: Asset.Colors.mainBG.color
        )
        
        beginButton.rx.tap
            .map { AuthorizationStep.begin(animated: true) }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        iAmHaveAccountButton.rx.tap
            .map { AuthorizationStep.login }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        createAccountButton.rx.tap
            .map { AuthorizationStep.registrate }
            .bind(to: steps)
            .disposed(by: disposeBag)
        
        beginButton.configureTapScaleAnimation()
            .disposed(by: disposeBag)
        
        iAmHaveAccountButton.configureTapScaleAnimation()
            .disposed(by: disposeBag)
        
        createAccountButton.configureTapScaleAnimation()
            .disposed(by: disposeBag)
        
        let presenterOutput = presenter.configure(input: presenterInput)
        
        rx.didShow.asDriver()
            .withLatestFrom(presenterOutput.isAuthorized)
            .filter(!)
            .map { _ in () }
            .drive(rx.startAnimations)
            .disposed(by: disposeBag)
        
        rx.viewDidAppear.asDriver()
            .withLatestFrom(presenterOutput.isAuthorized)
            .asObservable()
            .filter { $0 }
            .map { _ -> Step in AuthorizationStep.begin(animated: false) }
            .bind(to: steps)
            .disposed(by: disposeBag)
    }
    
    private func createUI() {
        view.addSubviews(
            bgImageView,
            logo,
            beginButton,
            iAmHaveAccountButton,
            createAccountButton
        )
        
        logo.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        createAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Size.button)
            $0.bottom.equalToSuperview().offset(-Margin.huge)
        }
        
        iAmHaveAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Size.button)
            $0.bottom.equalTo(createAccountButton.snp.top).offset(-Margin.mid)
        }
        
        beginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Size.button)
            $0.bottom.equalTo(iAmHaveAccountButton.snp.top).offset(-Margin.mid)
        }
    }
    
    fileprivate func resetAnimations() {
        beginButton.alpha = 0
        createAccountButton.alpha = 0
        iAmHaveAccountButton.alpha = 0
    }
    
    fileprivate func animateBG() {
        
        let bgImageHeight = view.frame.size.height
        let bgImageWidth = (Asset.Images.bgStart.image as UIImage).width(withHeight: bgImageHeight)
        
        bgImageView.snp.remakeConstraints {
            $0.height.equalTo(bgImageHeight)
            $0.width.equalTo(bgImageWidth)
            $0.left.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        UIView.animate(withDuration: 10) {
            self.bgImageView.alpha = 0.2
        }
        
        UIView.animate(
            withDuration: 100,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            let newLeft = (bgImageWidth - self.view.frame.size.width) * -1
            
            self.bgImageView.snp.updateConstraints {
                $0.left.equalToSuperview().offset(newLeft)
            }
            self.bgImageView.superview?.layoutIfNeeded()
            
        } completion: { _ in
            UIView.animate(withDuration: 2) {
                self.bgImageView.alpha = 0
            }
        }
    }
}

private extension Reactive where Base: StartViewController {
    
    var startAnimations: Binder<Void> {
        return Binder(base) { base, _ in
            base.animateBG()
            base.resetAnimations()
            base.logo.startAnimation {
                UIView.animate(withDuration: 0.3) {
                    base.beginButton.alpha = 1
                    base.createAccountButton.alpha = 1
                    base.iAmHaveAccountButton.alpha = 1
                }
            }
        }
    }
}
