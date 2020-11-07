//
//  StartView.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import Swinject
import PinLayout
import CombineCocoa
import RxFlow
import RxCocoa
import RxSwift

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

class StartViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
    private let presenter: StartPresenter
    
    fileprivate let logo = StartLogo()
    fileprivate let beginButton = UIButton()
    fileprivate let iAmHaveAccountButton = UIButton()
    fileprivate let createAccountButton = UIButton()
    fileprivate let bgImageView = UIImageView(image: Asset.Images.bgStart.image)
    
    private let disposeBag = DisposeBag()
    
    init(presenter: StartPresenter) {
        self.presenter = presenter
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
        
        navigationController?.setupLargeMainThemeNavBar()
        
        resetAnimations()
        
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.alpha = 0
        
        beginButton.setTitle(L10n.startBeginButtonTitle, for: .normal)
        beginButton.setRoundedFilledStyle(titleColor: Asset.Colors.mainBG.color)
        iAmHaveAccountButton.setTitle(L10n.startIHaveAccountButtonTitle, for: .normal)
        iAmHaveAccountButton.setRoundedBorderedStyle(
            bgColor: Asset.Colors.mainBG.color,
            borderColor: Asset.Colors.mainBG.color
        )
        createAccountButton.setTitle(L10n.startCreateAccountButtonTitle, for: .normal)
        createAccountButton.setRoundedBorderedStyle(
            bgColor: Asset.Colors.mainBG.color,
            borderColor: Asset.Colors.mainBG.color
        )
        
        let presenterInput = StartPresenter.Input(
            beginButtonTapped: beginButton.rx.tap.asSignal(),
            iAmHaveAccountButtonTapped: iAmHaveAccountButton.rx.tap.asSignal(),
            createAccountButtonTapped: createAccountButton.rx.tap.asSignal()
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
    }
    
    fileprivate func resetAnimations() {
        beginButton.alpha = 0
        createAccountButton.alpha = 0
        iAmHaveAccountButton.alpha = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        logo.pin
            .center()
        
        createAccountButton.pin
            .hCenter()
            .size(Sizes.button)
            .bottom(Margin.huge)
        
        iAmHaveAccountButton.pin
            .hCenter()
            .size(Sizes.button)
            .above(of: createAccountButton)
            .marginBottom(Margin.mid)
        
        beginButton.pin
            .hCenter()
            .size(Sizes.button)
            .above(of: iAmHaveAccountButton)
            .marginBottom(Margin.mid)
    }
    
    fileprivate func animateBG() {
        
        let bgImageHeight = view.frame.size.height
        let bgImageWidth = (Asset.Images.bgStart.image as UIImage).width(withHeight: bgImageHeight)
        
        bgImageView.pin
            .height(bgImageHeight)
            .width(bgImageWidth)
            .left()
            .vertically()
        
        UIView.animate(withDuration: 10) {
            self.bgImageView.alpha = 0.2
        }
        
        UIView.animate(
            withDuration: 100,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            let newLeft = (bgImageWidth - self.view.frame.size.width) * -1
            self.bgImageView.pin
                .height(bgImageHeight)
                .width(bgImageWidth)
                .left(newLeft)
                .vertically()
            
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