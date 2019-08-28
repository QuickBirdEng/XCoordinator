//
//  Router+Combine.swift
//  XCoordinatorCombine
//
//  Created by Paul Kraft on 28.08.19.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(Combine) && canImport(XCoordinator)

import Combine
import XCoordinator

@available(iOS 13.0, *)
extension Router {
    
    public func triggerFuture(_ route: RouteType, with options: TransitionOptions = .init(animated: true)) -> Future<Void, Never> {
        return Future { completion in
            self.trigger(route, with: options) {
                completion(.success(()))
            }
        }
    }
    
}

#endif
