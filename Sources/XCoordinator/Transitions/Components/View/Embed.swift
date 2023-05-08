//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

public struct Embed<RootViewController> {

    // MARK: Stored Properties

    private let presentable: () -> any Presentable
    private let container: any Container

    // MARK: Initialization

    public init(in container: any Container, _ presentable: @escaping () -> any Presentable) {
        self.container = container
        self.presentable = presentable
    }

}

extension Embed: TransitionComponent where RootViewController: UIViewController {

    public func build() -> Transition<RootViewController> {
        let presentable = presentable()
        return Transition(presentables: [presentable], animationInUse: nil) { rootViewController, options, completion in
            container.viewController.addChild(presentable.viewController)

            presentable.viewController.view.translatesAutoresizingMaskIntoConstraints = false
            container.view.addSubview(presentable.viewController.view)

            // swiftlint:disable force_unwrapping
            NSLayoutConstraint.activate([
                NSLayoutConstraint(item: container.view!, attribute: .leading, relatedBy: .equal,
                                   toItem: presentable.viewController.view, attribute: .leading, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: container.view!, attribute: .trailing, relatedBy: .equal,
                                   toItem: presentable.viewController.view, attribute: .trailing, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: container.view!, attribute: .top, relatedBy: .equal,
                                   toItem: presentable.viewController.view, attribute: .top, multiplier: 1, constant: 0),
                NSLayoutConstraint(item: container.view!, attribute: .bottom, relatedBy: .equal,
                                   toItem: presentable.viewController.view, attribute: .bottom, multiplier: 1, constant: 0)
            ])
            // swiftlint:enable force_unwrapping

            presentable.viewController.didMove(toParent: container.viewController)

            presentable.presented(from: rootViewController)
            completion?()
        }
    }

}
