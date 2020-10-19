
import UIKit

public extension UIButton {
    
    func hide(animated: Bool = true) {
        UIView.animate(
            withDuration: animated ? 0.3 : 0) {
            self.alpha = 0
        }
    }
    
    func show(animated: Bool = true) {
        UIView.animate(
            withDuration: animated ? 0.3 : 0) {
            self.alpha = 1
        }
    }
}
