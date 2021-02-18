//
//  File.swift
//  
//
//  Created by Sergey Borovikov on 18.02.2021.
//

import Foundation
import RxCocoa
import RxSwift

public protocol AlertActionsConfigurable {
    var actions: [AlertActionConfiguration] { get }
}

public struct AlertActions: AlertActionsConfigurable {
    public let actions: [AlertActionConfiguration]
}

extension AlertConfiguration: AlertActionsConfigurable {
}

public final class RxErrorProvider: SharedSequenceConvertibleType {

    public typealias Element = AlertConfigurationProtocol
    public typealias SharingStrategy = SignalSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _relay = PublishRelay<AlertConfigurationProtocol>()
    private let _providing: SharedSequence<SharingStrategy, AlertConfigurationProtocol>

    public init() {
        _providing = _relay.asSignal()
    }

    fileprivate func provideErrorOfObservable<
        O: ObservableConvertibleType,
        SSP: SharingStrategyProtocol
    >(
        _ source: O,
        config: AlertActionsConfigurable? = nil,
        onErrorDriveWith sequence: SharedSequence<SSP, O.Element>
    ) -> SharedSequence<SSP, O.Element> {
        return source.asSharedSequence(
            sharingStrategy: SSP.self,
            onErrorRecover: {

                self.provide(config: config, error: $0)
                return sequence
            }
        )
    }

    fileprivate func provideErrorOfObservable<
        O: ObservableConvertibleType,
        SSP: SharingStrategyProtocol
    >(
        _ source: O,
        config: AlertActionsConfigurable? = nil,
        onErrorJustReturn element: O.Element
    ) -> SharedSequence<SSP, O.Element> {
        return source.asSharedSequence(
            sharingStrategy: SSP.self,
            onErrorRecover: {

                self.provide(config: config, error: $0)
                return SharedSequence<SSP, O.Element>.just(element)
            }
        )
    }
    
    private func provide(config: AlertActionsConfigurable?, error: Error) {
        _lock.lock()
        defer { _lock.unlock() }

        let alertConfig: AlertConfigurationProtocol
        switch config {
        case let _config as AlertActions:
            alertConfig = AlertConfiguration(
                message: error.localizedDescription,
                actions: _config.actions
            )
        case let _config as AlertConfiguration:
            alertConfig = _config
        default:
            alertConfig = AlertConfiguration(message: error.localizedDescription)
        }

        _relay.accept(alertConfig)
    }
    
    public func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _providing
    }
}

public extension ObservableConvertibleType {

    func provideError<SSP: SharingStrategyProtocol>(
        _ errorProvider: RxErrorProvider,
        config: AlertActionsConfigurable? = nil,
        onErrorDriveWith sequence: SharedSequence<SSP, Element> = .empty()
    ) -> SharedSequence<SSP, Element> {
        return errorProvider.provideErrorOfObservable(
            self,
            config: config,
            onErrorDriveWith: sequence
        )
    }

    func provideError<SSP: SharingStrategyProtocol>(
        _ errorProvider: RxErrorProvider,
        config: AlertActionsConfigurable? = nil,
        onErrorJustReturn element: Element
    ) -> SharedSequence<SSP, Element> {
        return errorProvider.provideErrorOfObservable(
            self,
            config: config,
            onErrorJustReturn: element
        )
    }
}

public protocol AlertConfigurationProtocol { }

public struct AlertActionConfiguration {
    
    public enum Style {

        case `default`
        case destructive
        case cancel
    }
    
    public let title: String
    public let style: Style
    public let action: () -> Void
}

public extension AlertActionConfiguration {
    
    static func ok(_ action: @escaping () -> Void = { }) -> AlertActionConfiguration {
        return AlertActionConfiguration(
            title: "😀 Ok",
            style: .default,
            action: action
        )
    }
    
    static func cancel(_ action: @escaping () -> Void = { }) -> AlertActionConfiguration {
        return AlertActionConfiguration(
            title: "😐 Cancel",
            style: .default,
            action: action
        )
    }
    
    static func close(_ action: @escaping () -> Void = { }) -> AlertActionConfiguration {
          return AlertActionConfiguration(
              title: "💀 Close",
              style: .default,
              action: action
          )
      }
}

public struct AlertConfiguration: AlertConfigurationProtocol {
    
    public let title: String
    public let message: String
    public let actions: [AlertActionConfiguration]
    public let onDismiss: (() -> ())?
    
    public init(title: String = "Внимание", message: String, actions: [AlertActionConfiguration] = [.ok()], onDismiss: (() -> ())? = nil) {
        self.title = title
        self.message = message
        self.actions = actions
        self.onDismiss = onDismiss
    }
}

public struct ActionSheetConfiguration: AlertConfigurationProtocol {
    
    public let title: String?
    public let actions: [AlertActionConfiguration]
    public let onCancel: () -> Void
    
    public init(title: String? = nil, actions: [AlertActionConfiguration], onCancel: @escaping () -> Void) {
        self.title = title
        self.actions = actions
        self.onCancel = onCancel
    }
}
