//
//  Transition.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public protocol Transition {
    associatedtype RootViewController: UIViewController

    static func generateRootViewController() -> RootViewController
    var presentable: Presentable? { get }
    func perform<C: Coordinator>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where C.TransitionType == Self
}
