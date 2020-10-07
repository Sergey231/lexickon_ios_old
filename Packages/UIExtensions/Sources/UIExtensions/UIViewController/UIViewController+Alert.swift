
import UIKit
import RxSwift

public extension UIViewController {
    
    func showMsg(
        title: String = "Ошибка!",
        msg: String,
        style: UIAlertController.Style = .actionSheet,
        button: String = "ok"
    ) -> Observable<Void> {
        let buttonTap = PublishSubject<Void>()
        
        let alert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: style
        )
        
        let button = UIAlertAction(
            title: button,
            style: .cancel
        ) { _ in
            buttonTap.onNext(())
        }
        
        alert.addAction(button)
        present(alert, animated: true, completion: nil)
        
        return buttonTap.asObserver()
    }
}
