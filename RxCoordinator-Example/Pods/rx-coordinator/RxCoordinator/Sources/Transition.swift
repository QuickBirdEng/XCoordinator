//
//  Transition.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public struct Transition {
    internal enum `Type` {
        case push(UIViewController)
        case present(UIViewController)
        case embed(viewController: UIViewController, container: Container)
        case pop
        case popToRoot
        case dismiss
        case none
    }

    internal let type: Type
    internal let animation: Animation?

    public static func push(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(type: .push(presentable.viewController), animation: animation)
    }

    public static func present(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        return Transition(type: .present(presentable.viewController), animation: animation)
    }

    public static func embed(_ presentable: Presentable, in container: Container) -> Transition {
        return Transition(type: .embed(viewController: presentable.viewController, container: container), animation: nil)
    }

    public static func pop(animation: Animation? = nil) -> Transition {
        return Transition(type: .pop, animation: animation)
    }

    public static func popToRoot(animation: Animation? = nil) -> Transition {
        return Transition(type: .popToRoot, animation: animation)
    }

    public static func dismiss(animation: Animation? = nil) -> Transition {
        return Transition(type: .dismiss, animation: animation)
    }

}

