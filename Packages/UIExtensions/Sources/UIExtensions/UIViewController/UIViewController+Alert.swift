
import UIKit
import RxSwift

public extension UIViewController {
    
    func showMsg(
        title: String = "Ошибка!",
        msg: String,
        style: UIAlertController.Style = .actionSheet,
        buttonTitle: String = "Ok",
        buttonColor: UIColor = .blue
    ) -> Observable<Void> {
        let buttonTap = PublishSubject<Void>()
        
        let alert = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: style
        )
        
        let button = UIAlertAction(
            title: buttonTitle,
            style: .cancel
        ) { _ in
            buttonTap.onNext(())
        }
        
        button.setValue(buttonColor, forKey: "titleTextColor")
        
        alert.addAction(button)
        present(alert, animated: true, completion: nil)
        
        return buttonTap.asObserver()
    }
}
