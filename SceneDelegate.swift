//
//  SceneDelegate.swift
//  lexickon_ios
//
//  Created by Sergey Borovikov on 7/6/19.
//  Copyright © 2019 Sergey Borovikov. All rights reserved.
//

import UIKit
import RxSwift
import RxFlow

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?
    var coordinator = FlowCoordinator()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        coordinator.debug().disposed(by: disposeBag)

        window = UIWindow(windowScene: windowScene)
        
        guard let window = self.window else { return }
        
        let appFlow = AppFlow()
        
        Flows.use(appFlow, when: .ready) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        coordinator.coordinate(flow: appFlow, with: AppStepper())
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

private extension FlowCoordinator {
    func debug() -> CompositeDisposable {
        let willNavigateDisposable = rx.willNavigate.subscribe(onNext: { flow, step in
            print("🚀 \(flow) ==> \(step)")
        })

        let didNavigateDisposable = rx.didNavigate.subscribe(onNext: { flow, step in
            print("👋 \(flow) ==> \(step)")
        })
        
        return CompositeDisposable(
            disposables: [
                willNavigateDisposable,
                didNavigateDisposable
            ]
        )
    }
}
