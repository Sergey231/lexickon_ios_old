//
//  WordCardViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 10.06.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import RxSwift
import LXControlKit
import UIExtensions
import RxExtensions
import Resolver
import Assets

final class WordCardViewController: UIViewController, Stepper {
    
    let steps = PublishRelay<Step>()
    
//    @Injected var presenter: WordCardPresenter

    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBG.color
        createUI()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    private func createUI() {
        
    }
    
    private func configureUI() {
        
    }
}

private extension Reactive where Base: WordCardViewController {
    
}

