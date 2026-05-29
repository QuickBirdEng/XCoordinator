//
//  TransitionContext.swift
//  XCoordinator
//
//  Created by Paul Kraft on 13.09.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// A non-generic view of a performed transition, used where the concrete root-view-controller type
/// is not known — e.g. on `Router`, whose only knowledge is its `RouteType`.
///
/// The context-based `trigger` variants (`contextTrigger`, the async overload, and the Combine/RxSwift
/// wrappers) hand back the performed transition as `any TransitionContext`. Deep linking
/// (`General/DeepLinking.swift`) uses ``presentables`` to walk the resulting coordinator tree.
///
@MainActor
public protocol TransitionContext {

    /// The presentables introduced into the view hierarchy by the transition.
    var presentables: [any Presentable] { get }
}
