#if os(iOS) || os(tvOS) || os(macOS)
import Foundation
#if os(iOS) || os(tvOS)
	import UIKit
	public typealias Button = UIKit.UIButton
#elseif os(macOS)
	import Cocoa
	public typealias Button = Cocoa.NSButton
#endif
import RxSwift
import RxCocoa

public extension Reactive where Base: Button {
	/// Binds enabled state of action to button, and subscribes to rx_tap to execute action.
	/// These subscriptions are managed in a private, inaccessible dispose bag. To cancel
	/// them, set the rx.action to nil or another action.
    var action: CocoaAction? {
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

				// Technically, this file is only included on tv/iOS platforms,
				// so this optional will never be nil. But let's be safe 😉
				let lookupControlEvent: ControlEvent<Void>?

				#if os(tvOS)
					lookupControlEvent = self.primaryAction
				#elseif os(iOS) || os(macOS)
					lookupControlEvent = self.tap
				#endif

				guard let controlEvent = lookupControlEvent else {
					return
				}

				controlEvent
					.bind(to: action.inputs)
					.disposed(by: self.base.actionDisposeBag)
			}
		}
	}

	/// Binds enabled state of action to button, and subscribes to rx_tap to execute action with given input transform.
	/// These subscriptions are managed in a private, inaccessible dispose bag. To cancel
	/// them, call bindToAction with another action or call unbindAction().
    func bind<Input, Output>(to action: Action<Input, Output>, inputTransform: @escaping (Base) -> (Input)) {
		// This effectively disposes of any existing subscriptions.
		unbindAction()

		// Technically, this file is only included on tv/iOS platforms,
		// so this optional will never be nil. But let's be safe 😉
		let lookupControlEvent: ControlEvent<Void>?

		#if os(tvOS)
			lookupControlEvent = self.primaryAction
		#elseif os(iOS) || os(macOS)
			lookupControlEvent = self.tap
		#endif

		guard let controlEvent = lookupControlEvent else {
			return
		}
		self.bind(to: action, controlEvent: controlEvent, inputTransform: inputTransform)
	}

	/// Binds enabled state of action to button, and subscribes to rx_tap to execute action with given input value.
	/// These subscriptions are managed in a private, inaccessible dispose bag. To cancel
	/// them, call bindToAction with another action or call unbindAction().
    func bind<Input, Output>(to action: Action<Input, Output>, input: Input) {
		self.bind(to: action) { _ in input }
	}
}
#endif
