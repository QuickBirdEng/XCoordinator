//
//  UIViewController+Extras.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

import UIKit

extension UIViewController {

    internal var topPresentedViewController: UIViewController {
        presentedViewController?.topPresentedViewController ?? self
    }

}
