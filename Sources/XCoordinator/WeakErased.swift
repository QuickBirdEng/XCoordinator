//
//  WeakErased.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

///
/// A `WeakRouter` is a weak version of a router object to be used in view controllers or view models.
///
/// - Note:
///     Do not create a `WeakRouter` from a `StrongRouter` since `StrongRouter` is only another wrapper
///     and does not represent the  might instantly.
///     Also keep in mind that once the original router object has been deallocated,
///     calling `trigger` on this wrapper will have no effect.
///
public typealias WeakRouter<RouteType: Route> = WeakErased<StrongRouter<RouteType>>

///
/// `WeakErased` is a property wrapper to hold objects with a weak reference when using type-erasure.
///
/// Create this wrapper using an initial value and a closure to create the type-erased object.
/// Make sure to not create a `WeakErased` wrapper for already type-erased objects,
/// since their reference is most likely instantly lost.
///
#if swift(>=5.1)
@propertyWrapper
#endif
public struct WeakErased<Value> {
    private var _value: () -> Value?
    
    /// The type-erased or otherwise mapped version of the value being held weakly.
    public var wrappedValue: Value? {
        return _value()
    }
    
    ///
    /// Create a `WeakErased` wrapper using an initial value and a closure to create the type-erased object.
    /// Make sure to not create a `WeakErased` wrapper for already type-erased objects,
    /// since their reference is most likely instantly lost.
    ///
    public init<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = WeakErased.createValueClosure(for: value, erase: erase)
    }
    
    ///
    /// Set a new value by providing a non-type-erased value and a closure to create the type-erased object.
    ///
    public mutating func set<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = WeakErased.createValueClosure(for: value, erase: erase)
    }
    
    private static func createValueClosure<Erasable: AnyObject>(
        for value: Erasable,
        erase: @escaping (Erasable) -> Value) -> () -> Value? {
        return { [weak value] in
            guard let value = value else { return nil }
            return erase(value)
        }
    }
}

import UIKit

extension WeakErased: Presentable where Value: Presentable {
    
    public var viewController: UIViewController! {
        return wrappedValue?.viewController
    }
    
}

extension WeakErased: Router where Value: Router {
    
    public func contextTrigger(_ route: Value.RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        wrappedValue?.contextTrigger(route, with: options, completion: completion)
    }
    
}
