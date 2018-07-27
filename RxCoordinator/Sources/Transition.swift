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
    var presentable: Presentable? { get }
    func perform<R: Route>(options: TransitionOptions, coordinator: AnyCoordinator<R>, completion: PresentationHandler?) where R.TransitionType == Self
}
