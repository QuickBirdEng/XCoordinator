//
//  RoutingContextContaining.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.05.23.
//  Copyright © 2023 QuickBird Studios. All rights reserved.
//

#if canImport(SwiftUI)

@available(iOS 13.0, tvOS 13.0, *)
internal protocol RoutingContextContaining {

    func replaceRoutingContext(with router: any Router, override: Bool)

}

#endif
