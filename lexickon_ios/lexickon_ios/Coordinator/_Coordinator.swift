//
//  Coordinator.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 23.01.2020.
//  Copyright © 2020 Sergey Borovikov. All rights reserved.
//

import UIKit

typealias CompletionBlock = ()->()
typealias RouterCompletions = [UIViewController : CompletionBlock]

protocol _Coordinator: class {
    
    var childCoordinators: [_Coordinator] { get set }
    
    var navigationController: UINavigationController { get set }
    var completions: RouterCompletions { get set }
    
    func startFlow()
    
    //MARK: Navigation methods
    func present(_ module: Presentable?, animated: Bool)
    func push(_ module: Presentable?, animated: Bool, completion: CompletionBlock?)
    func popModule(animated: Bool)
    func dismissModule(animated: Bool, completion: CompletionBlock?)
    func setRootModule(_ module: Presentable?, hideBar: Bool, animated: Bool)
    func popToRootModule(animated: Bool)
}

protocol Presentable {
    
    var toPresent: UIViewController? { get }
}

extension UIViewController: Presentable {
    
    var toPresent: UIViewController? {
        return self
    }
}

//MARK: Coordinators Hierarhcy Implementation
extension _Coordinator {
    
    func addChild(_ coordinator: _Coordinator) {
        for element in childCoordinators {
            if element === coordinator {
                return
            }
        }
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: _Coordinator?) {
        guard
            !childCoordinators.isEmpty,
            let coordinator = coordinator
        else { return }
        
        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}

//MARK: Default Implementation Of Navigation Methods
extension _Coordinator {
    
    func present(_ module: Presentable?, animated: Bool = true) {
        guard let controller = module?.toPresent else { return }
        navigationController.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool = true, completion: CompletionBlock? = nil) {
        guard
            let controller = module?.toPresent,
            !(controller is UINavigationController)
        else {
            assertionFailure("⚠️Deprecated push UINavigationController.")
            return
        }
        
        if let completion = completion {
            completions[controller] = completion
        }
        navigationController.pushViewController(controller, animated: animated)
    }
    
    func popModule(animated: Bool = true)  {
        if let controller = navigationController.popViewController(animated: animated) {
            finishFlow(for: controller)
        }
    }
    
    func dismissModule(animated: Bool = true, completion: CompletionBlock? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool = false, animated: Bool = false) {
        guard let controller = module?.toPresent else { return }
        navigationController.setViewControllers([controller], animated: animated)
        navigationController.isNavigationBarHidden = hideBar
    }
    
    func popToRootModule(animated: Bool = true) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                finishFlow(for: controller)
            }
        }
    }
    
    func finishFlow(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }
}
