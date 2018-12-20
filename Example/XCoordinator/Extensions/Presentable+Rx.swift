//
//  Presentable+Rx.swift
//  XCoordinator_Example
//
//  Created by Paul Kraft on 15.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(XCoordinator) && canImport(UIKit) && canImport(RxSwift) && canImport(RxCocoa)

import RxCocoa
import RxSwift
import UIKit
import XCoordinator

extension Reactive where Base: Presentable {
    public var dismissal: Observable<Void>! {
        guard let viewController = base.viewController else {
            return nil
        }
        return viewController.rx
            .methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
            .map { _ in }
            .filter { [weak viewController] in
                guard let viewController = viewController else { return false }
                return viewController.isBeingDismissed || viewController.isMovingFromParent
            }
    }
}

#endif
