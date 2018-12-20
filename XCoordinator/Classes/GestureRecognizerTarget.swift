//
//  GestureRecognizerTarget.swift
//  XCoordinator
//
//  Created by Paul Kraft on 19.12.18.
//

import Foundation

internal protocol GestureRecognizerTarget {
    var gestureRecognizer: UIGestureRecognizer? { get }
}

internal class Target<GestureRecognizer: UIGestureRecognizer>: GestureRecognizerTarget {

    // MARK: - Stored properties

    private let handler: (GestureRecognizer) -> Void
    internal private(set) weak var gestureRecognizer: UIGestureRecognizer?

    // MARK: - Init

    init(recognizer gestureRecognizer: GestureRecognizer, handler: @escaping (GestureRecognizer) -> Void) {
        self.handler = handler
        self.gestureRecognizer = gestureRecognizer
        gestureRecognizer.addTarget(self, action: #selector(handle))
    }

    // MARK: - Target actions

    @objc
    private func handle(_ gestureRecognizer: UIGestureRecognizer) {
        guard let recognizer = gestureRecognizer as? GestureRecognizer else { return }
        handler(recognizer)
    }
}
