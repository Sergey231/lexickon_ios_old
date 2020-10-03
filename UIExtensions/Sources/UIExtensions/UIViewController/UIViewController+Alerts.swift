
import Foundation
import UIKit
import RxSwift

extension UIViewController {
    
    public func alert(
        isActionSheet: Bool = true,
        msgTitle: String = "Ошибка",
        msgText: String,
        bottonColor: UIColor = .blue
    ) -> Observable<Void> {
        
        let okActionSubject = PublishSubject<Void>()
        
        let alertStyle = isActionSheet
            ? UIAlertController.Style.actionSheet
            : .alert
        
        let alertController = UIAlertController(
            title: msgTitle,
            message: msgText,
            preferredStyle: alertStyle
        )
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .cancel
        ) { _ in okActionSubject.onNext(()) }
        
        okAction.setValue(
            bottonColor,
            forKeyPath: "titleTextColor"
        )
        
        alertController.addAction(okAction)
        
        present(
            alertController,
            animated: true,
            completion: nil
        )
        
        return okActionSubject.asObservable()
    }
}
