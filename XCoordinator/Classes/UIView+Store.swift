//
//  UIView+Store.swift
//  XCoordinator
//
//  Created by Stefan Kofler on 19.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

private var associatedObjectHandle: UInt8 = 0

extension UIView {

    var strongReferences: [Any] {
        get {
            return objc_getAssociatedObject(self, &associatedObjectHandle) as? [Any] ?? []
        }
        set {
            objc_setAssociatedObject(self, &associatedObjectHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UIView {

    @discardableResult
    func removePreviewingContext<TransitionType: TransitionProtocol>(for _: TransitionType.Type)
        -> UIViewControllerPreviewing? {
        guard let existingContextIndex = strongReferences
            .index(where: { $0 is CoordinatorPreviewingDelegateObject<TransitionType> }),
            let contextDelegate = strongReferences
                .remove(at: existingContextIndex) as? CoordinatorPreviewingDelegateObject<TransitionType>,
            let context = contextDelegate.context else {
                return nil
        }
        return context
    }
}
