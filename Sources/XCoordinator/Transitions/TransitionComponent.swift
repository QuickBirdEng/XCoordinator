//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public protocol TransitionComponent<RootViewController> {

    associatedtype RootViewController: UIViewController

    func build() -> Transition<RootViewController>

}

extension Transition {

    public init(@TransitionBuilder<RootViewController> transitions: () -> Self) {
        self = transitions()
    }

}
