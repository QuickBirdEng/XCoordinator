//
//  ReferenceBox.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 18.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// A ReferenceBox can be used to dynamically change the retain strategy of a certain reference, i.e.
/// it can dynamically switch between holding an object strongly or weakly.
///
public class ReferenceBox<T: AnyObject> {

    // MARK: - Stored properties

    private weak var weakReference: T?
    private var strongReference: T?

    // MARK: - Initialization

    ///
    /// Creates a ReferenceBox with an optional start value.
    ///
    /// - Parameter value:
    ///     The start value. If you specify `nil` here, no reference is set.
    ///     In this case, an object needs to be set (by using the `set` method)
    ///     before it can be accessed (using the `get` method).
    ///
    public init(_ value: T? = nil) {
        if let value = value {
            set(value)
        }
    }

    // MARK: - Methods

    ///
    /// Sets the strong and weak references to point to the specified object.
    ///
    /// - Parameter value:
    ///     The object to be referenced.
    ///
    public func set(_ value: T) {
        strongReference = value
        weakReference = value
    }

    ///
    /// This method can be used to retrieve the value set in the initializer or using the `set` method.
    ///
    /// - Note:
    ///     It may return `nil`, if the held object was already deallocated due to the reference counter becoming zero.
    ///
    public func get() -> T? {
        return strongReference ?? weakReference
    }

    ///
    /// This method can be used to release the strong reference held to the object it is referencing to.
    /// It will not remove the weak reference to the object and, therefore, as long as it is still held
    /// strongly by another reference, you can access the value using the `get` method.
    ///
    public func releaseStrongReference() {
        strongReference = nil
    }
}
