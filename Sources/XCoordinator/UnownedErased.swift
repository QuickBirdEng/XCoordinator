//
//  File.swift
//  
//
//  Created by Paul Kraft on 21.06.19.
//

import Foundation

#if swift(>=5.1)

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
}

#else

///
/// `UnownedErased` is a property wrapper to hold objects with an unowned reference when using type-erasure.
///
/// Create this wrapper using an initial value and a closure to create the type-erased object.
/// Make sure to not create an `UnownedErased` wrapper for already type-erased objects,
/// since their reference is most likely instantly lost.
///
public struct UnownedErased<Value> {
    private var _value: () -> Value
    
    /// The type-erased or otherwise mapped version of the value being held unowned.
    public var wrappedValue: Value {
        _value()
    }
}

#endif

extension UnownedErased {

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
        { [unowned value] in erase(value) }
    }
}
