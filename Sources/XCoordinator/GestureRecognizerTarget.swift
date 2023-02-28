//
//  GestureRecognizerTarget.swift
//  XCoordinator
//
//  Created by Paul Kraft on 19.12.18.
//

import UIKit

internal protocol GestureRecognizerTarget {
    var gestureRecognizer: UIGestureRecognizer? { get }
}

internal class Target<GestureRecognizer: UIGestureRecognizer>: GestureRecognizerTarget {

    // MARK: Stored properties

    private let handler: (GestureRecognizer) -> Void
    internal private(set) weak var gestureRecognizer: UIGestureRecognizer?

    // MARK: Initialization

    init(recognizer gestureRecognizer: GestureRecognizer, handler: @escaping (GestureRecognizer) -> Void) {
        self.handler = handler
        self.gestureRecognizer = gestureRecognizer
        // The method signature "handle(_ gestureRecognizer: UIGestureRecognizer)" is in conflict with validation Apple, use another name : "handleMyGesture"
        gestureRecognizer.addTarget(self, action: #selector(handleGesture(of: )))
    }

    // MARK: Target actions

    @objc
    private func handleGesture(of gestureRecognizer: UIGestureRecognizer) {
        guard let recognizer = gestureRecognizer as? GestureRecognizer else { return }
        handler(recognizer)
    }
}
