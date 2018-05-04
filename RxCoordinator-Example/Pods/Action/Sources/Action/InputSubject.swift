import Foundation
import RxSwift

/// A special subject for Action.inputs. It only emits `.next` event.
public class InputSubject<Element>: ObservableType, Cancelable, SubjectType, ObserverType {

    public typealias E = Element
    typealias Key = UInt

    /// Indicates whether the subject has any observers
    public var hasObservers: Bool {
        _lock.lock()
        let count = _observers.count > 0
        _lock.unlock()
        return count
    }
    
    // state
    private let _lock = NSRecursiveLock()
    private var _nextKey: Key = 0
    private var _observers: [Key: (Event<Element>) -> ()] = [:]
    private var _isDisposed = false

    /// Indicates whether the subject has been isDisposed.
    public var isDisposed: Bool {
        _lock.lock()
        let isDisposed = _isDisposed
        _lock.unlock()
        return isDisposed
    }

    /// Creates a subject.
    public init() {
        #if TRACE_RESOURCES
        _ = Resources.incrementTotal()
        #endif
    }

    /// Notifies all subscribed observers abount only `.next` event.
    ///
    /// - parameter event: Event to send to the observers.
    public func on(_ event: Event<Element>) {
        _lock.lock()
        switch event {
        case .next(_) where !_isDisposed:
            _observers.values.forEach { $0(event) }
        default:
            break
        }
        _lock.unlock()
    }

    /**
     Subscribes an observer to the subject.

     - parameter observer: Observer to subscribe to the subject.
     - returns: Disposable object that can be used to unsubscribe the observer from the subject.
     */
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == Element {
        _lock.lock()

        if _isDisposed {
            observer.on(.error(RxError.disposed(object: self)))
            return Disposables.create()
        }
        
        let key = _nextKey
        _nextKey += 1
        _observers[key] = observer.on
        _lock.unlock()

        return Disposables.create { [weak self] in
            self?._lock.lock()
            self?._observers.removeValue(forKey: key)
            self?._lock.unlock()
        }
    }
    
    /// Unsubscribe all observers and release resources.
    public func dispose() {
        _lock.lock()
        _isDisposed = true
        _observers.removeAll()
        _lock.unlock()
    }

    #if TRACE_RESOURCES
    deinit {
        _ = Resources.decrementTotal()
    }
    #endif

}
