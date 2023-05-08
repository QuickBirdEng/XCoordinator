//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

import UIKit

extension UIViewController {

    internal var topPresentedViewController: UIViewController {
        presentedViewController?.topPresentedViewController ?? self
    }

}
