//
//  File.swift
//  
//
//  Created by Paul Kraft on 21.06.19.
//

import Foundation

public typealias UnownedRouter<RouteType: Route> = UnownedErased<StrongRouter<RouteType>>

@propertyWrapper @dynamicMemberLookup
public struct UnownedErased<Value> {
    private var _value: () -> Value
    
    public var wrappedValue: Value {
        _value()
    }
    
    public init<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = UnownedErased.createValueClosure(for: value, erase: erase)
    }
    
    public mutating func set<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = UnownedErased.createValueClosure(for: value, erase: erase)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
        wrappedValue[keyPath: keyPath]
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
