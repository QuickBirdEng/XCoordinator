#if os(iOS) || os(tvOS)
import UIKit
import RxSwift
import RxCocoa
import ObjectiveC

public extension Reactive where Base: UIBarButtonItem {

    /// Binds enabled state of action to bar button item, and subscribes to rx_tap to execute action.
    /// These subscriptions are managed in a private, inaccessible dispose bag. To cancel
    /// them, set the rx.action to nil or another action.
    public var action: CocoaAction? {
        get {
            var action: CocoaAction?
            action = objc_getAssociatedObject(self.base, &AssociatedKeys.Action) as? Action
            return action
        }

        set {
            // Store new value.
            objc_setAssociatedObject(self.base, &AssociatedKeys.Action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            // This effectively disposes of any existing subscriptions.
            self.base.resetActionDisposeBag()
            
            // Set up new bindings, if applicable.
            if let action = newValue {
                action
                    .enabled
                    .bind(to: self.isEnabled)
                    .disposed(by: self.base.actionDisposeBag)
                
                self.tap.subscribe(onNext: {
                    action.execute(())
                })
                .disposed(by: self.base.actionDisposeBag)
            }
        }
    }

    public func bind<Input, Output>(to action: Action<Input, Output>, inputTransform: @escaping (Base) -> (Input)) {
        unbindAction()

        self.tap
            .map { inputTransform(self.base) }
            .bind(to: action.inputs)
            .disposed(by: self.base.actionDisposeBag)

        action
            .enabled
            .bind(to: self.isEnabled)
            .disposed(by: self.base.actionDisposeBag)
    }

    public func bind<Input, Output>(to action: Action<Input, Output>, input: Input) {
        self.bind(to: action) { _ in input}
    }

    /// Unbinds any existing action, disposing of all subscriptions.
    public func unbindAction() {
        self.base.resetActionDisposeBag()
    }
}
#endif
