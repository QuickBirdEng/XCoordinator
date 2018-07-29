//
//  UIView+Store.swift
//  rx-coordinator
//
//  Created by Stefan Kofler on 19.07.18.
//

import UIKit
import ObjectiveC

private var AssociatedObjectHandle: UInt8 = 0

extension UIView {

    var strongReferences: [Any] {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? [Any] ?? []
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
