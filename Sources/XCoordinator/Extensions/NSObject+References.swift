//
//  NSObject+References.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 19.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import Foundation

private var associatedObjectHandle: UInt8 = 0

extension NSObject {

    internal var strongReferences: [Any] {
        get {
            objc_getAssociatedObject(self, &associatedObjectHandle) as? [Any] ?? []
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

