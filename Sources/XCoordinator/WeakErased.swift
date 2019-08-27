//
//  WeakErased.swift
//  XCoordinator
//
//  Created by Paul Kraft on 30.10.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

public typealias WeakRouter<RouteType: Route> = WeakErased<StrongRouter<RouteType>>

@propertyWrapper @dynamicMemberLookup
public struct WeakErased<Value> {
    private var _value: () -> Value?
    
    public var wrappedValue: Value? {
        _value()
    }
    
    public init<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = WeakErased.createValueClosure(for: value, erase: erase)
    }
    
    public mutating func set<Erasable: AnyObject>(_ value: Erasable, erase: @escaping (Erasable) -> Value) {
        self._value = WeakErased.createValueClosure(for: value, erase: erase)
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T? {
        wrappedValue?[keyPath: keyPath]
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
        wrappedValue?.viewController
    }
    
}

extension WeakErased: Router where Value: Router {
    
    public func contextTrigger(_ route: Value.RouteType, with options: TransitionOptions, completion: ContextPresentationHandler?) {
        wrappedValue?.contextTrigger(route, with: options, completion: completion)
    }
    
}
