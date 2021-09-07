//
//  StartExercisersViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 06.09.2021.
//  Copyright © 2021 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow
import SnapKit
import LXUIKit
import UIExtensions
import RxExtensions
import Resolver
import Assets
import LBTATools

class StartExercisesViewController: UIViewController, Stepper {
    
    struct UIConstants {
        
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected private var presenter: StartExercisesPresenter
    
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
        .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    //MARK: Create UI
    private func createUI() {
        view.backgroundColor = .red
    }
    
    //MARK: Configure UI
    private func configureUI() {
        _ = presenter.configure(input: .init())
    }
}

