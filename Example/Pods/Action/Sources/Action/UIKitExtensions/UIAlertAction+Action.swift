#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
import RxCocoa

#if swift(>=4.2)
public typealias ActionStyle = UIAlertAction.Style
#else
public typealias ActionStyle = UIAlertActionStyle
#endif

public extension UIAlertAction {

    static func Action(_ title: String?, style: ActionStyle) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: { action in
            action.rx.action?.execute()
            return
        })
    }
}

public extension Reactive where Base: UIAlertAction {

    /// Binds enabled state of action to button, and subscribes to rx_tap to execute action.
    /// These subscriptions are managed in a private, inaccessible dispose bag. To cancel
    /// them, set the rx.action to nil or another action.
    var action: CocoaAction? {
        get {
            var action: CocoaAction?
            action = objc_getAssociatedObject(base, &AssociatedKeys.Action) as? Action
            return action
        }

        set {
            // Store new value.
            objc_setAssociatedObject(base, &AssociatedKeys.Action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            // This effectively disposes of any existing subscriptions.
            self.base.resetActionDisposeBag()

            // Set up new bindings, if applicable.
            if let action = newValue {
                action
                    .enabled
                    .bind(to: self.enabled)
                    .disposed(by: self.base.actionDisposeBag)
            }
        }
    }

    var enabled: AnyObserver<Bool> {
        return AnyObserver { [weak base] event in
            MainScheduler.ensureExecutingOnScheduler()

            switch event {
            case .next(let value):
                base?.isEnabled = value
            case .error(let error):
                let error = "Binding error to UI: \(error)"
                #if DEBUG
                    fatalError(error)
                #else
                    print(error)
                #endif
                break
            case .completed:
                break
            }
        }
    }
}
#endif
