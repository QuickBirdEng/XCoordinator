import Foundation
import RxSwift

public extension Action {
    /// Filters out `notEnabled` errors and returns
    /// only underlying error from `ActionError`
    public var underlyingError: Observable<Error> {
        return errors.flatMap { actionError -> Observable<Error> in
            guard case .underlyingError(let error) = actionError else {
                return Observable.empty()
            }
            return Observable.just(error)
        }
    }
}

public extension Action where Input == Void {
    /// use to trigger an action.
    @discardableResult
    public func execute() -> Observable<Element> {
        return execute(())
    }
}
