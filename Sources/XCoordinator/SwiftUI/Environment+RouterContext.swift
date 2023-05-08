//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import Foundation
import SwiftUI

@available(iOS 13.0, tvOS 13.0, *)
private enum RouterContextKey: EnvironmentKey {
    static var defaultValue: RouterContext { .init() }
}

@available(iOS 13.0, tvOS 13.0, *)
extension EnvironmentValues {
    public var router: RouterContext {
        get { self[RouterContextKey.self] }
        set { self[RouterContextKey.self] = newValue }
    }
}

#endif
