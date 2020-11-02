//
//  HomeViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import Swinject
import PinLayout
import Combine
import CombineCocoa
import RxFlow
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController, Stepper {
    
    struct UIConstants {
        static let profileIconSize: CGFloat = 44
        static let profileIconRightMargin: CGFloat = 16
        static let headerHeight: CGFloat = 260
    }
    
    let steps = PublishRelay<Step>()
    
    let profileIconView = ProfileIconView()
    let headerView = HomeHeaderView()
    let tableView = UITableView()
    
    fileprivate var disposeBag = DisposeBag()
    
    fileprivate let presenter: HomePresenter
    
    init(
        presenter: HomePresenter
    ) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("💀 Home")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        createUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileIconView.pin
            .size(UIConstants.profileIconSize)
            .right(16)
            .top(view.pin.safeArea.top)
        
        tableView.pin.all()
    }
    
    private func configureUI() {
        profileIconView.backgroundColor = .gray
        profileIconView.configure(input: ProfileIconView.Input())
            .didTap
            .map { _ in MainStep.profile }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(
            top: UIConstants.headerHeight - 50,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        tableView.rx.didScroll.asDriver()
            .map { _ in self.tableView.contentOffset.y * -1 }
            .map { $0 < 120 ? 120 : $0 }
            .drive(headerView.rx.height)
            .disposed(by: disposeBag)
    }
    
    private func createUI() {
        view.addSubviews(
            tableView,
            headerView,
            profileIconView
        )
    }
}

extension HomeViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
       
        if
            operation == .push,
            let homeVC = fromVC as? HomeViewController,
            let profileVC = toVC as? ProfileMainScreenViewController
        {
            return ToProfileAnimator(
                homeVC: homeVC,
                profileVC: profileVC
            )
        }
        
        if
            operation == .pop,
            let homeVC = toVC as? HomeViewController,
            let profileVC = fromVC as? ProfileMainScreenViewController
        {
            return ToHomeAnimator(
                homeVC: homeVC,
                profileVC: profileVC
            )
        }
        
        return nil
    }
}
