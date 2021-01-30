//
//  HomeViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 26.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import RxSwift
import UIExtensions
import RxDataSources
import Resolver
import UIComponents
import Lottie
import Assets

final class HomeViewController: UIViewController, Stepper {
    
    struct UIConstants {
        static let profileIconSize: CGFloat = 44
        static let profileIconRightMargin: CGFloat = 16
        static let headerHeight: CGFloat = 210
        static let addButtonSize: CGFloat = 100
        fileprivate static let refreshTopMargin: CGFloat = 140
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: HomePresenter
    fileprivate var disposeBag = DisposeBag()
    private var dataSource: HomeWordRxDataSource!
    private let needToRefrash = PublishRelay<Void>()
    
    fileprivate let refreshView = RefreshView()
    private let headerView = HomeHeaderView()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    // public for Animator
    let profileIconView = ProfileIconView()
    let addWordButton = AddWordButtonView()
    
    init() {
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

    private func configureUI() {
        
        let presenterOutput = presenter.configurate(
            input: .init(needLoadNextWordsPage: needToRefrash.asSignal())
        )
        
        configureTableView(with: presenterOutput.sections)
        
        profileIconView.configure(input: ProfileIconView.Input())
            .didTap
            .map { _ in MainStep.profile }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        let tableViewContentOffsetY = tableView.rx
            .didScroll
            .asDriver()
            .map { _ in self.tableView.contentOffset.y * -1 }
            
        tableViewContentOffsetY
            .map { $0 < 120 ? 120 : $0 }
            .drive(headerView.rx.height)
            .disposed(by: disposeBag)
        
        let refreshProgress = tableViewContentOffsetY
            .map { ($0 - 257) / 50 }
            .map { $0 > 1 ? 1 : $0 }
            
        refreshProgress
            .drive(rx.refresh)
            .disposed(by: disposeBag)
        
        
           
        refreshView.configure(
            input: .init(animateActivity: refreshProgress.map { $0 >= 1 } )
        )
    }
    
    private func createUI() {
        
        tableView.setup {
            $0.delegate = self
            $0.rowHeight = 100
            $0.register(cellType: HomeWordCell.self)
            $0.backgroundColor = .clear
            $0.separatorStyle = .none
            $0.contentInset = UIEdgeInsets(
                top: UIConstants.headerHeight,
                left: 0,
                bottom: 0,
                right: 0
            )
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.left.top.equalToSuperview()
                $0.height.equalTo(UIConstants.headerHeight)
            }
        }
        
        headerView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
            }
        }
        
        refreshView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(UIConstants.refreshTopMargin)
                $0.size.equalTo(34)
            }
        }
        
        profileIconView.setup {
            $0.backgroundColor = .gray
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.profileIconSize)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            }
        }
        
        addWordButton.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.addButtonSize)
                $0.bottom.equalToSuperview().offset(-Margin.mid)
                $0.right.equalToSuperview()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureTableView(with models: Driver<[HomeWordSectionModel]>) {
        
        var configureCell: HomeWordRxDataSource.ConfigureCell {
            return { _, tableView, indexPath, model in
                let cell: HomeWordCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configurate(with: model)
                return cell
            }
        }
        
        dataSource = HomeWordRxDataSource(
            animationConfiguration: AnimationConfiguration(),
            configureCell: configureCell
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
            let profileVC = toVC as? ProfileMainScreenViewController,
            fromVC is HomeViewController
        {
            return FromHomeToProfileAnimator(
                profileVCProfileIconView: profileVC.profileIconView,
                profileVCProfileIconViewSize: ProfileMainScreenViewController.UIConstants.profileIconSize,
                homeVCProfileIconView: profileIconView,
                profileIconTopMargin: ProfileMainScreenViewController.UIConstants.profileIconTopMargin
            )
        }
        
        if fromVC is HomeViewController && toVC is AddSearchWordViewController {
            return FromHomeToNewWordAnimator(
                headerViewHeight: AddSearchWordViewController.UIConstants.headerViewHeight,
                addWordButton: addWordButton
            )
        }
        
        return nil
    }
    
    private func handlePopTransitioning(
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if
            let profileVC = fromVC as? ProfileMainScreenViewController,
            toVC is HomeViewController
        {
            return FromProfileToHomeAnimator(
                profileVCProfileIconView: profileVC.profileIconView,
                homeVCProfileIconView: profileIconView,
                homeVCProfileIconSize: HomeViewController.UIConstants.profileIconSize,
                homeVCProfileIconRightMargin: HomeViewController.UIConstants.profileIconRightMargin
            )
        }
        
        if
            let addSearchWordVC = fromVC as? AddSearchWordViewController,
            toVC is HomeViewController
        {
            return FromNewWordToHomeAnimator(
                addSearchWordVCHeaderViewFrame: addSearchWordVC.headerView.frame,
                homeVCAddWordButton: addWordButton,
                addSearchWordVCHeaderView: addSearchWordVC.headerView
            )
        }
        
        return nil
    }
}

private extension Reactive where Base: HomeViewController {
    var refresh: Binder<CGFloat> {
        Binder(base) { base, refreshProgress in
            base.refreshView.alpha = refreshProgress
            base.refreshView.refreshImageView.transform = CGAffineTransform(rotationAngle: refreshProgress * -5)
            base.refreshView.snp.updateConstraints {
                let newTopMargin = HomeViewController.UIConstants.refreshTopMargin
                    + (HomeViewController.UIConstants.refreshTopMargin * (refreshProgress/6))
                $0.top.equalTo(newTopMargin)
            }
        }
    }
}
