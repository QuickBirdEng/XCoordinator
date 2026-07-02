//
//  ChildLifecycleObserver.swift
//  XCoordinator
//
//  Created by Paul Kraft.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

///
/// A hidden, non-interactive marker view that reports when its host view leaves the window.
///
/// `BaseCoordinator` attaches one to each view-loaded child's `viewController.view` so that a child
/// whose view controller is torn down through a path XCoordinator does not mediate — a modal dismiss,
/// an interactive swipe-dismiss, SwiftUI removing a hosted coordinator, or app code calling
/// `dismiss()`/`removeFromParent()` directly — still triggers the parent's `removeChildrenIfNeeded()`
/// sweep promptly, instead of lingering until the next ancestor transition.
///
/// The observer only reports the *leave* event (`window == nil`); the parent defers the actual sweep to
/// the next runloop and re-validates against `isInViewHierarchy`, so a controller that is merely covered,
/// backgrounded, or transiently hidden is never pruned.
///
@MainActor
internal final class ChildLifecycleObserver: UIView {

    // MARK: Stored Properties

    private var onLeftHierarchy: () -> Void

    // MARK: Initialization

    internal init(onLeftHierarchy: @escaping () -> Void) {
        self.onLeftHierarchy = onLeftHierarchy
        super.init(frame: .zero)
        isUserInteractionEnabled = false
        isHidden = true
        isAccessibilityElement = false
        accessibilityElementsHidden = true
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    /// Repoints the observer at a new owner, e.g. when its host view controller is re-added as a child
    /// of a different coordinator. Reused instead of adding a second observer to the same view.
    internal func repoint(_ onLeftHierarchy: @escaping () -> Void) {
        self.onLeftHierarchy = onLeftHierarchy
    }

    override internal func didMoveToWindow() {
        super.didMoveToWindow()
        // Only react to leaving a window. Entering is a no-op here — the parent's deferred re-check
        // would find the controller in-hierarchy and skip anyway.
        guard window == nil else { return }
        onLeftHierarchy()
    }

}
