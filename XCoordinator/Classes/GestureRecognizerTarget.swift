//
//  GestureRecognizerTarget.swift
//  XCoordinator
//
//  Created by Paul Kraft on 19.12.18.
//

import Foundation

internal class GestureRecognizerTarget {

    // MARK: - Stored properties

    private var handler: (UIGestureRecognizer) -> Void
    internal weak var gestureRecognizer: UIGestureRecognizer?

    // MARK: - Init

    init(recognizer gestureRecognizer: UIGestureRecognizer, handler: @escaping (UIGestureRecognizer) -> Void) {
        self.handler = handler
        self.gestureRecognizer = gestureRecognizer
        gestureRecognizer.addTarget(self, action: #selector(handle))
    }

    // MARK: - Target actions

    @objc
    open func handle(_ gestureRecognizer: UIGestureRecognizer) {
        handler(gestureRecognizer)
    }
}
