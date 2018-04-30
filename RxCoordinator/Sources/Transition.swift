//
//  Transition.swift
//  RxCoordinator
//
//  Created by Stefan Kofler on 30.04.18.
//  Copyright © 2018 Stefan Kofler. All rights reserved.
//

import Foundation
import UIKit

public enum Transition {
    case push(UIViewController)
    case present(UIViewController)
    case embed(UIViewController, to: Container)
    case pop
    case popToRoot
    case dismiss
}
