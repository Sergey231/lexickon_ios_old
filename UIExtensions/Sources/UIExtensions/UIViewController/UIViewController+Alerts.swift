
import Foundation
import UIKit
import Combine

extension UIViewController {
    
    public func alert(
        isActionSheet: Bool = true,
        msgTitle: String = "Ошибка",
        msgText: String,
        bottonColor: UIColor = .blue
    ) -> AnyPublisher<Void, Never> {
        
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
        ) { action in
            print("⚽️ action: \(action)")
        }
        
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
        
        return Just(()).eraseToAnyPublisher()
    }
}
