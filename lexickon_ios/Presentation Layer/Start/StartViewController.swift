//
//  StartViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 4/29/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import PinLayout
import RxCocoa
import RxSwift

class StartViewController: UIViewController {

    private var presenter: StartPresenterProtocol
    private let disposeBag = DisposeBag()
    
    private let startLogoView = StartLogoView()
    private let beginButton = ButtonControl(
        text: L10n.begin,
        style: .filled(
            tintColor: UIColor.white,
            textColor: Asset.Colors.mainBG.color
        )
    )
    private let iHaveAccountButton = ButtonControl(text: L10n.iHaveAccountButtonTitle)
    private let createAccountButton = ButtonControl(text: L10n.createAccount)
    
    convenience init(presenter: StartPresenterProtocol) {
        self.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOfNil: Bundle?) {
        self.presenter = StartPresenter()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOfNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        configureUI()
    }
    
    private func createUI() {
        [startLogoView,
         beginButton,
         iHaveAccountButton,
         createAccountButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = Asset.Colors.mainBG.color
        beginButton.alpha = 0
        iHaveAccountButton.alpha = 0
        createAccountButton.alpha = 0
        
        beginButton.rx.tap
            .subscribe(onNext: {
            print("beginButton")
        }).disposed(by: disposeBag)
        
        iHaveAccountButton.rx.tap
            .subscribe(onNext: {
                print("iHaveAccountButton")
            }).disposed(by: disposeBag)
        
        createAccountButton.rx.tap
            .subscribe(onNext: {
                print("createAccountButton")
            }).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let buttonsAnimation = Observable.merge(
            createAccountButton.appear().asObservable(),
            iHaveAccountButton.appear().asObservable(),
            beginButton.appear().asObservable()
        )
        
        Observable.concat(
            startLogoView.animate().asObservable(),
            buttonsAnimation
        ).subscribe().disposed(by: disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        
        startLogoView.pin
            .height(94)
            .width(200)
            .center()
        
        createAccountButton.pin
            .height(ButtonControl.Constants.height)
            .width(ButtonControl.Constants.width)
            .hCenter()
            .bottom(48)
        
        iHaveAccountButton.pin
            .height(ButtonControl.Constants.height)
            .width(ButtonControl.Constants.width)
            .hCenter()
            .above(of: createAccountButton).marginBottom(16)
        
        beginButton.pin
            .height(ButtonControl.Constants.height)
            .width(ButtonControl.Constants.width)
            .hCenter()
            .above(of: iHaveAccountButton).marginBottom(16)
    }
}
