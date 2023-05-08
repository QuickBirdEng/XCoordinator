//
//  File.swift
//  
//
//  Created by Paul Kraft on 08.05.23.
//

#if canImport(SwiftUI)

import Foundation

@available(iOS 13.0, tvOS 13.0, *)
public protocol RouterContextReplacable {
    func replaceContext(with router: any Router)
}

#endif
