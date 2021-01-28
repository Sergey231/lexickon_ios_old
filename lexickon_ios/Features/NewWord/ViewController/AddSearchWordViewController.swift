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
import UIComponents
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
    fileprivate let activityIndicator = UIActivityIndicatorView()
    fileprivate let activityView = AnimationView()
    
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
    
    private func createUI() {
        
        activityIndicator.setup {
            $0.color = Asset.Colors.baseText.color
            $0.style = .large
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        
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
            $0.animation = Animation.named("42327-random-s")
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(headerView.snp.bottom)
            }
        }
        
        
        tableView.setup {
            $0.rowHeight = 100
            $0.register(cellType: TranslationResultCell.self)
            view.addSubview($0)
            $0.snp.makeConstraints {
                $0.left.right.bottom.equalToSuperview()
                $0.top.equalTo(headerView.snp.bottom)
            }
        }
    }
    
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
    }
    
    private func configureTableView(with models: Driver<[TranslationReulstSectionModel]>) {
        
        var configureCell: TranslationReulstRxDataSource.ConfigureCell {
            return { _, tableView, indexPath, model in
                let cell: TranslationResultCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configurate(with: model)
                return cell
            }
        }
        
        dataSource = TranslationReulstRxDataSource(
            animationConfiguration: AnimationConfiguration(),
            configureCell: configureCell
        )
        
        models
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

private extension Reactive where Base: AddWordHeaderView {
    var height: Binder<CGFloat> {
        return Binder(base) { base, height in
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
        return Binder(base) { base, isLoading in
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
}
