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
import UIExtensions
import RxDataSources

final class HomeViewController: UIViewController, Stepper {
    
    typealias HomeWordSectionModel = AnimatableSectionModel<String, HomeWordViewModel>
    typealias RxDataSource = RxTableViewSectionedAnimatedDataSource<HomeWordSectionModel>
    
    struct UIConstants {
        static let profileIconSize: CGFloat = 44
        static let profileIconRightMargin: CGFloat = 16
        static let headerHeight: CGFloat = 260
    }
    
    let steps = PublishRelay<Step>()
    
    let profileIconView = ProfileIconView()
    let headerView = HomeHeaderView()
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    let needToRefrash = PublishRelay<Void>()
    
    fileprivate var disposeBag = DisposeBag()
    
    fileprivate let presenter: HomePresenter
    private var dataSource: RxDataSource!
    
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
        view.backgroundColor = .white
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        createUI()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        profileIconView.pin
            .size(UIConstants.profileIconSize)
            .right(Margin.regular)
            .top(view.pin.safeArea.top)
        
        tableView.pin.all()
    }
    
    private func configureUI() {
        
        let presenterOutput = presenter.configurate(
            input: .init(needLoadNextWordsPage: needToRefrash.asSignal())
        )
        
        configureTableView(with: presenterOutput.sections)
        
        profileIconView.backgroundColor = .gray
        profileIconView.configure(input: ProfileIconView.Input())
            .didTap
            .map { _ in MainStep.profile }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        
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
    
    private func configureTableView(with models: Driver<[HomeWordSectionModel]>) {
        
        var configureCell: RxDataSource.ConfigureCell {
            return { _, tableView, indexPath, model in
                let cell: HomeWordCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configurate(with: model)
                return cell
            }
        }
        
        dataSource = RxDataSource(
            animationConfiguration: AnimationConfiguration(),
            configureCell: configureCell
        )
        
        tableView.rowHeight = 100
        tableView.register(cellType: HomeWordCell.self)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(
            top: UIConstants.headerHeight - 50,
            left: 0,
            bottom: 0,
            right: 0
        )
        
        models
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .lightGray
        return headerView
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
