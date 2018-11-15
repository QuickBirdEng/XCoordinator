import Foundation
import RxSwift

internal struct AssociatedKeys {
    static var Action = "rx_action"
    static var DisposeBag = "rx_disposeBag"
}

// Note: Actions performed in this extension are _not_ locked
// So be careful!
internal extension NSObject {

    // A dispose bag to be used exclusively for the instance's rx.action.
    internal var actionDisposeBag: DisposeBag {
        var disposeBag: DisposeBag

        if let lookup = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBag) as? DisposeBag {
            disposeBag = lookup
        } else {
            disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, disposeBag, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        return disposeBag
    }

    // Resets the actionDisposeBag to nil, disposeing of any subscriptions within it.
    internal func resetActionDisposeBag() {
        objc_setAssociatedObject(self, &AssociatedKeys.DisposeBag, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    // Uses objc_sync on self to perform a locked operation.
    internal func doLocked(_ closure: () -> Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        closure()
    }
}
