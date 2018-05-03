//
//  Animation.swift
//  RxCoordinator
//
//  Created by Joan Disho on 03.05.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public class Animation: NSObject, UIViewControllerTransitioningDelegate {

    public let presentationAnimation: TranistionAnimation?
    public let dismissalAnimation: TranistionAnimation?

    public init(presentationAnimation: TranistionAnimation?, dismissalAnimation: TranistionAnimation?) {
        self.presentationAnimation = presentationAnimation
        self.dismissalAnimation = dismissalAnimation
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentationAnimation
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissalAnimation
    }

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentationAnimation as? UIViewControllerInteractiveTransitioning
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissalAnimation as? UIViewControllerInteractiveTransitioning
    }

}

