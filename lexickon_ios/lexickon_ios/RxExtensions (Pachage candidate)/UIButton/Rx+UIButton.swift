import RxSwift
import RxCocoa
import UIKit

public extension Reactive where Base : UIButton {
   
    public var valid: Binder<Bool> {
        return Binder(self.base) { button, valid in
            button.isEnabled = valid
            UIView.animate(withDuration: 0.2) {
                button.alpha = valid ? 1 : 0.5
            }
        }
    }
}
