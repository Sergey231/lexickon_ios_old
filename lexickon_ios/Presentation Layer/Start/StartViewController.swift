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
        
        view.backgroundColor = Asset.Colors.mainBG.color
        
        view.addSubview(startLogoView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startLogoView.animate().drive().disposed(by: disposeBag)
    }
    
    override func viewWillLayoutSubviews() {
        
        startLogoView.pin
            .height(94)
            .width(200)
            .center()
    }
}
