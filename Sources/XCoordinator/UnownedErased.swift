//
//  File.swift
//  
//
//  Created by Paul Kraft on 21.06.19.
//

import Foundation

///
/// An `UnownedRouter` is an unowned version of a router object to be used in view controllers or view models.
///
/// - Note:
///     Do not create an `UnownedRouter` from a `StrongRouter` since `StrongRouter` is only another wrapper
///     and does not represent the  might instantly
///
public typealias UnownedRouter<RouteType: Route> = UnownedErased<StrongRouter<RouteType>>

///
/// `UnownedErased` is a property wrapper to hold objects with an unowned reference when using type-erasure.
///
/// Create this wrapper using an initial value and a closure to create the type-erased object.
/// Make sure to not create an `UnownedErased` wrapper for already type-erased objects,
/// since their reference is most likely instantly lost.
///
@propertyWrapper
public struct UnownedErased<Value> {
    private var _value: () -> Value
    
    /// The type-erased or otherwise mapped version of the value being held unowned.
    public var wrappedValue: Value {
        _value()
    }
    
    ///
    /// Create an `UnownedErased` wrapper using an initial value and a closure to create the type-erased object.
    /// Make sure to not create an `UnownedErased` wrapper for already type-erased objects,
    /// since their reference is most likely instantly lost.
    ///
    public init<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = UnownedErased.createValueClosure(for: value, erase: erase)
    }
    
    ///
    /// Set a new value by providing a non-type-erased value and a closure to create the type-erased object.
    ///
    public mutating func set<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = UnownedErased.createValueClosure(for: value, erase: erase)
    }
    
    private static func createValueClosure<Erasable: AnyObject>(
        for value: Erasable,
        erase: @escaping (Erasable) -> Value) -> () -> Value {
        return { [unowned value] in erase(value) }
    }
}

import UIKit

extension UnownedErased: Presentable where Value: Presentable {
    
    public var viewController: UIViewController! {
        wrappedValue.viewController
    }
    
}

extension UnownedErased: Router where Value: Router {
    
    public func contextTrigger(_ route: Value.RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        wrappedValue.contextTrigger(route, with: options, completion: completion)
    }
    
}
