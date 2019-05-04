#if os(iOS)
import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIRefreshControl {

    // Binds enabled state of action to refresh control, and subscribes to value changed control event to execute action.
    // These subscriptions are managed in a private, inaccessible dispose bag. To cancel
    // them, set the rx.action to nil or another action.

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
                self.bind(to: action, input: ())
            }
        }
    }

    func bind<Input, Output>(to action: Action<Input, Output>, inputTransform: @escaping (Base) -> (Input)) {
        unbindAction()

        self.controlEvent(.valueChanged)
            .map { inputTransform(self.base)}
            .bind(to: action.inputs)
            .disposed(by: self.base.actionDisposeBag)

        action
            .executing
            .bind(to: self.isRefreshing)
            .disposed(by: self.base.actionDisposeBag)

        action
            .enabled
            .bind(to: self.isEnabled)
            .disposed(by: self.base.actionDisposeBag)
    }

    func bind<Input, Output>(to action: Action<Input, Output>, input: Input) {
        self.bind(to: action) { _ in input}
    }

    /// Unbinds any existing action, disposing of all subscriptions.
    func unbindAction() {
        self.base.resetActionDisposeBag()
    }
}
#endif
