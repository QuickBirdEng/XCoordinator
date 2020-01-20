//
//  WeakErased.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

#if swift(>=5.1)

///
/// `WeakErased` is a property wrapper to hold objects with a weak reference when using type-erasure.
///
/// Create this wrapper using an initial value and a closure to create the type-erased object.
/// Make sure to not create a `WeakErased` wrapper for already type-erased objects,
/// since their reference is most likely instantly lost.
///
@propertyWrapper
public struct WeakErased<Value> {
    private var _value: () -> Value?
    
    /// The type-erased or otherwise mapped version of the value being held weakly.
    public var wrappedValue: Value? {
        _value()
    }
}

#else

///
/// `WeakErased` is a property wrapper to hold objects with a weak reference when using type-erasure.
///
/// Create this wrapper using an initial value and a closure to create the type-erased object.
/// Make sure to not create a `WeakErased` wrapper for already type-erased objects,
/// since their reference is most likely instantly lost.
///
public struct WeakErased<Value> {
    private var _value: () -> Value?
    
    /// The type-erased or otherwise mapped version of the value being held weakly.
    public var wrappedValue: Value? {
        _value()
    }
}

#endif

extension WeakErased {
    
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
        { [weak value] in value.map(erase) }
    }

}
