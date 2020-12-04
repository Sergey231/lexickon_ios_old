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
        static let addButtonSize: CGFloat = 100
    }
    
    let steps = PublishRelay<Step>()
    fileprivate let presenter: HomePresenter
    fileprivate var disposeBag = DisposeBag()
    private var dataSource: RxDataSource!
    private let needToRefrash = PublishRelay<Void>()
    
    private let headerView = HomeHeaderView()
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    // public for Animator
    let profileIconView = ProfileIconView()
    let addWordButton = AddWordButton()
    
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
        
        addWordButton.pin
            .size(UIConstants.addButtonSize)
            .bottom(Margin.mid)
            .right()
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
            profileIconView,
            addWordButton
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
        
        addWordButton.didTap
            .map { MainStep.addWord }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        models
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.numberOfRows(inSection: section) > 0 {
            let headerView = HomeWordsSectionHeaderView()
            let sectionType = HomeWordsSectionHeaderView.StudyWordsType(rawValue: section) ?? .waiting
            headerView.configure(input: HomeWordsSectionHeaderView.Input(studyWordsType: sectionType))
            return headerView
        }
        return nil
    }
}

extension HomeViewController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
       
        if operation == .push {
            return handlePushTransitioning(from: fromVC, to: toVC)
        } else if operation == .pop {
            return handlePopTransitioning(from: fromVC, to: toVC)
        }
        return nil
    }
    
    private func handlePushTransitioning(
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        if
            let homeVC = fromVC as? HomeViewController,
            let profileVC = toVC as? ProfileMainScreenViewController
        {
            return ToProfileAnimator(
                homeVC: homeVC,
                profileVC: profileVC
            )
        }
        
        if
            fromVC is HomeViewController,
            let addSearchWordVC = toVC as? AddSearchWordViewController
        {
            return ToNewWordAnimator(
                addSearchWordVC: addSearchWordVC
            )
        }
        
        return nil
    }
    
    private func handlePopTransitioning(
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if
            let homeVC = toVC as? HomeViewController,
            let profileVC = fromVC as? ProfileMainScreenViewController
        {
            return FromProfileToHomeAnimator(
                homeVC: homeVC,
                profileVC: profileVC
            )
        }
        
        if fromVC is AddSearchWordViewController && toVC is HomeViewController {
            return FromNewWordToHomeAnimator()
        }
        
        return nil
    }
}
