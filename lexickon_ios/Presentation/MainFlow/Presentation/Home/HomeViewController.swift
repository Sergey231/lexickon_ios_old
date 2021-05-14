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
import LXControlKit
import Lottie
import Assets
import LexickonApi

final class HomeViewController: UIViewController, Stepper {
    
    fileprivate struct UIConstants {
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
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped)
    fileprivate let paginationProgressView = PaginationProgressView()
    fileprivate let activityView = AnimationView()
    fileprivate let wordsEditPanelView = WordEditPanelView()
    
    // public for Animator
    let profileIconView = ProfileIconView()
    let addWordButton = AddSearchWordButton()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("💀 \(type(of: self)): \(#function)")
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

    // MARK: Create UI
    
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
                bottom: view.safeAreaInsets.bottom,
                right: 0
            )
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.right.left.top.equalToSuperview()
                $0.bottom.equalToSuperview()
            }
        }
        
        wordsEditPanelView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.small)
                $0.right.equalToSuperview().offset(-Margin.small)
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0)
            }
        }
        
        activityView.setup {
            $0.animation = Animation.named("linesLoading")
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalToSuperview().offset(257)
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
        
        paginationProgressView.setup {
            $0.setShadow()
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.equalToSuperview().offset(Margin.regular)
                $0.right.equalToSuperview().offset(-Margin.regular)
                $0.bottom.equalToSuperview().offset(-Margin.mid)
            }
        }
        
        addWordButton.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.size.equalTo(UIConstants.addButtonSize)
                $0.bottom.equalTo(paginationProgressView.snp.top).offset(-Margin.small)
                $0.right.equalToSuperview()
            }
        }
    }
    
    // MARK: Configure UI
    
    private func configureUI() {
        
        let refreshData = PublishRelay<Void>()
        let modelSelected = PublishRelay<HomeWordCellModel>()
        
        let presenterOutput = presenter.configurate(
            input: .init(
                refreshData: refreshData.asSignal(),
                needLoadNextWordsPage: needToRefrash.asSignal(),
                selectedWordCellModel: modelSelected.asSignal()
            )
        )
        
        configureTableView(with: presenterOutput.sections)
        tableView.rx.itemSelected.debug("😀").subscribe()
        tableView.rx.modelSelected(HomeWordCellModel.self)
            .asSignal()
            .debug("🔥")
            .emit(to: modelSelected)
            .disposed(by: disposeBag)
        
        profileIconView.configure(input: ProfileIconView.Input())
            .didTap
            .map { _ in MainStep.profile }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        let tableViewContentOffsetY = tableView.rx
            .didScroll
            .asDriver()
            .map { [unowned self] _ in self.tableView.contentOffset.y * -1 }
            
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
        
        refreshProgress
            .map { $0 >= 1 }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in () }
            .startWith(())
            .asSignal(onErrorSignalWith: .empty())
            .emit(to: refreshData)
            .disposed(by: disposeBag)
        
        let isWordsUpdating = refreshProgress
            .map { $0 > 0 }
            
        _ = headerView.configure(
            input: .init(isWordsUpdating: isWordsUpdating)
        )
           
        refreshView.configure(
            input: .init(animateActivity: presenterOutput.isWordsUpdating)
        )
        
        paginationProgressView.configure(
            input: .init(animateActivity: presenterOutput.isNextPageLoading)
        )
        
        let wordsEditPanelViewOutput = wordsEditPanelView.configure(
            input: WordEditPanelView.Input(
                learnCount: presenterOutput.wordsForLearn.map { UInt($0.count) },
                resetCount: presenterOutput.wordsForReset.map { UInt($0.count) },
                deleteCount: presenterOutput.wordsForDelete.map { UInt($0.count) },
                addingCount: .just(0)
            )
        )
        
//        wordsEditPanelViewOutput.addWordsDidTap.debug("📥").emit()
//        wordsEditPanelViewOutput.learnWordsDidTap.debug("🚀").emit()
//        wordsEditPanelViewOutput.resetWordsDidTap.debug("🧹").emit()
//        wordsEditPanelViewOutput.deleteWordsDidTap.debug("🔥").emit()
        
        presenterOutput.isWordsUpdating
            .drive(rx.isWordsLoading)
            .disposed(by: disposeBag)
        
        presenterOutput.disposables
            .disposed(by: disposeBag)
        
        presenterOutput.isEditMode
            .drive(rx.isEditMode)
            .disposed(by: disposeBag)
        
        Driver.combineLatest(
            presenterOutput.isEditMode,
            wordsEditPanelViewOutput.height
        ) { isEditMode, height -> CGFloat in
            isEditMode
                ? height
                : 0
        }
        .distinctUntilChanged()
        .drive(rx.wordsEditPanelViewHieght)
        .disposed(by: disposeBag)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            steps.accept(MainStep.addWord)
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

// MARK: UITableViewDelegate extension

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.numberOfRows(inSection: section) > 0 {
            let headerView = HomeWordsSectionHeaderView()
            let dataSourceSection = dataSource.sectionModels[section]
            let sectionType = StudyType(rawValue: dataSourceSection.model) ?? .waiting
            headerView.configure(input: HomeWordsSectionHeaderView.Input(studyType: sectionType))
            return headerView
        }
        return nil
    }
}

// MARK: NavigationControllerDelegate extension

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

// MARK: private Rx Extensions

private extension Reactive where Base: HomeViewController {
    var refresh: Binder<CGFloat> {
        Binder(base) { base, refreshProgress in
            base.refreshView.alpha = refreshProgress - 0.2
            base.refreshView.refreshImageView.transform = CGAffineTransform(
                rotationAngle: refreshProgress * -5
            )
            base.refreshView.snp.updateConstraints {
                let newTopMargin = HomeViewController.UIConstants.refreshTopMargin
                    + (HomeViewController.UIConstants.refreshTopMargin * (refreshProgress/6))
                $0.top.equalTo(newTopMargin)
            }
        }
    }
    
    var isWordsLoading: Binder<Bool> {
        Binder(base) { base, isLoading in
            UIView.animate(withDuration: 0.1) {
                base.tableView.alpha = isLoading ? 0 : 1
                base.activityView.alpha = isLoading ? 1 : 0
                if isLoading {
                    base.activityView.play(
                        fromFrame: nil,
                        toFrame: .init(30),
                        loopMode: .loop,
                        completion: nil
                    )
                } else {
                    base.activityView.stop()
                }
            }
        }
    }
    
    var isEditMode: Binder<Bool> {
        Binder(base) { base, isEditMode in
            
            UIView.animate(withDuration: 0.1) {
                base.profileIconView.alpha = isEditMode ? 0 : 1
                base.addWordButton.alpha = isEditMode ? 0 : 1
                base.wordsEditPanelView.alpha = isEditMode ? 1 : 0
            }
            
            UIView.animate(
                withDuration: 0.6,
                delay: 0,
                usingSpringWithDamping: 0.3,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut,
                animations: {
                    if isEditMode {
                        base.profileIconView.snp.remakeConstraints {
                            $0.size.equalTo(HomeViewController.UIConstants.profileIconSize)
                            $0.right.equalToSuperview().offset(-Margin.regular)
                            $0.top.equalTo(-Margin.huge)
                        }
                        base.addWordButton.snp.updateConstraints {
                            $0.bottom.equalTo(base.paginationProgressView.snp.top).offset(Margin.huge)
                        }
                        
                    } else {
                        base.profileIconView.snp.remakeConstraints {
                            $0.size.equalTo(HomeViewController.UIConstants.profileIconSize)
                            $0.right.equalToSuperview().offset(-Margin.regular)
                            $0.top.equalTo(base.view.safeAreaLayoutGuide.snp.top)
                        }
                        
                        base.addWordButton.snp.updateConstraints {
                            $0.bottom.equalTo(base.paginationProgressView.snp.top).offset(-Margin.small)
                        }
                    }
                    base.profileIconView.superview?.layoutIfNeeded()
                })
        }
    }
    
    var wordsEditPanelViewHieght: Binder<CGFloat> {
        Binder(base) { base, height in
            UIView.animate(withDuration: 0.3) {
                base.tableView.contentInset = UIEdgeInsets(
                    top: HomeViewController.UIConstants.headerHeight,
                    left: 0,
                    bottom: base.view.safeAreaInsets.bottom + height,
                    right: 0
                )
                base.wordsEditPanelView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                base.wordsEditPanelView.superview?.layoutIfNeeded()
            }
        }
    }
}
