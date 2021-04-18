//
//  AddSearchWordViewController.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 28.11.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit
import SnapKit
import RxFlow
import RxCocoa
import RxSwift
import LXControlKit
import UIExtensions
import RxDataSources
import Resolver
import Assets
import Lottie

final class AddSearchWordViewController: UIViewController, Stepper, UIGestureRecognizerDelegate {
    
    struct UIConstants {
        static let headerViewHeight: CGFloat = 156
    }
    
    let steps = PublishRelay<Step>()
    
    @Injected var presenter: AddSearchWordPresenter
    private var dataSource: TranslationReulstRxDataSource!
    fileprivate var disposeBag = DisposeBag()
    
    // Public for Custom transitioning animator
    let headerView = AddWordHeaderView()
    let placeholderView = AddSearchPlaceholderView()
    
    fileprivate let tableView = UITableView()
    fileprivate let activityView = AnimationView()
    fileprivate let wordsEditPanelView = WordEditPanelView()
    
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
        .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.placeholderView.stopFlaying()
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        createUI()
        configure()
    }
    
    // MARK: Create UI
    
    private func createUI() {
        
        placeholderView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.width.equalTo(200)
                $0.height.equalTo(140)
                $0.center.equalToSuperview()
            }
        }
        
        headerView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.height.equalTo(UIConstants.headerViewHeight)
            }
        }
        
        activityView.setup {
            $0.animation = Animation.named("linesLoading")
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(headerView.snp.bottom)
            }
        }
        
        tableView.setup {
            $0.register(cellType: MainTranslationResultCell.self)
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = 100
            $0.register(cellType: TranslationResultCell.self)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(headerView.snp.bottom)
            }
        }
        
        wordsEditPanelView.setup {
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.height.equalTo(0)
            }
        }
    }
    
    // MARK: Configure UI
    
    private func configure() {
        
        let headerViewOutput = headerView.configure()
            
        headerViewOutput.backButtonDidTap
            .map { NewWordStep.toHome }
            .emit(to: steps)
            .disposed(by: disposeBag)
        
        headerViewOutput.height
            .drive(headerView.rx.height)
            .disposed(by: disposeBag)
        
        let textForTranslate = headerViewOutput.text
            .debounce(.seconds(1))
            .asSignal(onErrorJustReturn: "")
        
        let presenterOutput = presenter.configurate(input: .init(textForTranslate: textForTranslate))
        
        configureTableView(with: presenterOutput.sections)
        
        presenterOutput.isLoading
            .drive(rx.isLoading)
            .disposed(by: disposeBag)
        
        let wordsEditPanelViewOutput = wordsEditPanelView.configure(
            input: WordEditPanelView.Input(
                learnCount: presenterOutput.wordsForLearn.map { UInt($0.count) },
                resetCount: presenterOutput.wordsForReset.map { UInt($0.count) },
                deleteCount: presenterOutput.wordsForDelete.map { UInt($0.count) },
                addingCount: presenterOutput.wordsForEdding.map { UInt($0.count) }
            )
        )
        
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
    
    private func configureTableView(with models: Driver<[TranslationsSection]>) {
        
        var configureCell: TranslationReulstRxDataSource.ConfigureCell {
            return { _, tableView, indexPath, model in
                switch model {
                case .Main(let mainCellModel):
                    return self.makeMainTranslationResultCell(with: mainCellModel, from: tableView)
                case .Other(let otherCellModel):
                    return self.makeTranslationResultCell(with: otherCellModel, from: tableView)
                }
            }
        }
        
        dataSource = TranslationReulstRxDataSource(configureCell: configureCell)
        
        models
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func makeMainTranslationResultCell(
        with model: MainTranslationCellModel,
        from table: UITableView
    ) -> MainTranslationResultCell {
        let cell = table.dequeueReusableCell(withCellType: MainTranslationResultCell.self)
        cell.configurate(with: model)
        return cell
    }
    
    private func makeTranslationResultCell(
        with model: OtherTranslationCellModel,
        from table: UITableView
    ) -> TranslationResultCell {
        let cell = table.dequeueReusableCell(withCellType: TranslationResultCell.self)
        cell.configurate(with: model)
        return cell
    }
}

private extension Reactive where Base: AddWordHeaderView {
    var height: Binder<CGFloat> {
        Binder(base) { base, height in
            UIView.animate(withDuration: 0.2) {
                base.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
                base.superview?.layoutIfNeeded()
            }
        }
    }
}

private extension Reactive where Base: AddSearchWordViewController {
    var isLoading: Binder<Bool> {
        Binder(base) { base, isLoading in
            UIView.animate(withDuration: 0.3) {
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
    
    var wordsEditPanelViewHieght: Binder<CGFloat> {
        Binder(base) { base, height in
            UIView.animate(withDuration: 0.3) {
                base.tableView.contentInset = UIEdgeInsets(
                    top: 0,
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
