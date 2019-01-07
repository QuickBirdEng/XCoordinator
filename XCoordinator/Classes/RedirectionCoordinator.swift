//
//  RedirectionCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 08.12.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

///
/// RedirectionCoordinators can be used to break up huge routes into smaller ones, like dividing a flow into subflows.
/// In contrast to the RedirectionRouter, the RedirectionCoordinator does not need to know about the coordinator's RouteType
/// but instead keeps a dependency on its TransitionType.
///
/// Create a RedirectionCoordinator from a superCoordinator by providing a reference to the superCoordinator.
/// Triggered routes of the RedirectionCoordinator will be mapped to the superCoordinator's TransitionType
/// and performed using the superCoordinator's rootViewController.
/// Please provide either a `prepareTransition` closure in the initializer or override the `prepareTransition(for:)` method.
///
/// A RedirectionCoordinator has a viewController, which is used in transitions, e.g. when presenting, pushing or otherwise displaying it.
///
open class RedirectionCoordinator<RouteType: Route, TransitionType: TransitionProtocol>: Coordinator {

    // MARK: - Stored properties

    private let superTransitionPerformer: AnyTransitionPerformer<TransitionType>
    private let viewControllerBox = ReferenceBox<UIViewController>()
    private let _prepareTransition: ((RouteType) -> TransitionType)?

    // MARK: - Computed properties

    /// The viewController used in transitions, e.g. when presenting, pushing or otherwise displaying a RedirectionCoordinator.
    public var rootViewController: TransitionType.RootViewController {
        return superTransitionPerformer.rootViewController
    }

    open var viewController: UIViewController! {
        return viewControllerBox.get()
    }

    // MARK: - Initialization

    ///
    /// Creates a RedirectionCoordinator with a viewController, a superTransitionPerfomer and an optional `prepareTransition` closure.
    ///
    /// - Parameter viewController:
    ///     The viewController used in transitions, e.g. when presenting, pushing or otherwise displaying a RedirectionCoordinator.
    ///
    /// - Parameter superTransitionPerformer:
    ///     The superCoordinator's AnyTransitionPerformer object. All transitions are redirected to it.
    ///
    /// - Parameter prepareTransition:
    ///     A closure preparing transitions for triggered routes.
    ///     If you specify `nil` here, make sure to override `prepareTransiton(for:)`.
    ///     If you override `prepareTransition(for:)`, this closure will be ignored.
    ///
    public init(viewController: UIViewController,
                superTransitionPerformer: AnyTransitionPerformer<TransitionType>,
                prepareTransition: ((RouteType) -> TransitionType)?) {

        viewControllerBox.set(viewController)
        self.superTransitionPerformer = superTransitionPerformer
        _prepareTransition = prepareTransition
    }

    ///
    /// Creates a RedirectionCoordinator with a viewController, a superTransitionPerfomer and an optional `prepareTransition` closure.
    ///
    /// - Parameter viewController:
    ///     The viewController used in transitions, e.g. when presenting, pushing or otherwise displaying a RedirectionCoordinator.
    ///
    /// - Parameter superTransitionPerformer:
    ///     The superCoordinator. All transitions are redirected to it.
    ///
    /// - Parameter prepareTransition:
    ///     A closure preparing transitions for triggered routes.
    ///     If you specify `nil` here, make sure to override `prepareTransiton(for:)`.
    ///     If you override `prepareTransition(for:)`, this closure will be ignored.
    ///
    public init<T: TransitionPerformer>(viewController: UIViewController,
                                        superTransitionPerformer: T,
                                        prepareTransition: ((RouteType) -> TransitionType)?
        ) where T.TransitionType == TransitionType {

        viewControllerBox.set(viewController)
        self.superTransitionPerformer = AnyTransitionPerformer(superTransitionPerformer)
        _prepareTransition = prepareTransition
    }

    // MARK: - Methods

    open func presented(from presentable: Presentable?) {
        viewController?.presented(from: presentable)
        viewControllerBox.releaseStrongReference()
    }

    open func prepareTransition(for route: RouteType) -> TransitionType {
        guard let prepareTransition = _prepareTransition else {
            fatalError("Please override \(#function) or provide a prepareTransition-closure in the initializer.")
        }
        return prepareTransition(route)
    }

    public func performTransition(_ transition: TransitionType,
                                  with options: TransitionOptions,
                                  completion: PresentationHandler?) {
        superTransitionPerformer.performTransition(transition, with: options, completion: completion)
    }
}

// MARK: - Deprecated

extension RedirectionCoordinator {

    ///
    /// Creates a RedirectionCoordinator with a viewController, a superCoordinaror and an optional `prepareTransition` closure.
    ///
    /// - Parameter viewController:
    ///     The viewController used in transitions, e.g. when presenting, pushing or otherwise displaying a RedirectionCoordinator.
    ///
    /// - Parameter superCoordinator:
    ///     The superCoordinator. All transitions are redirected to it.
    ///
    /// - Parameter prepareTransition:
    ///     A closure preparing transitions for triggered routes.
    ///     If you specify `nil` here, make sure to override `prepareTransiton(for:)`.
    ///     If you override `prepareTransition(for:)`, this closure will be ignored.
    ///
    @available(*, deprecated, renamed: "init(viewController:superTransitionPerfomer:prepareTransition:)")
    public convenience init<C: Coordinator>(viewController: UIViewController,
                                            superCoordinator: C,
                                            prepareTransition: ((RouteType) -> TransitionType)?) where C.TransitionType == TransitionType {
        self.init(viewController: viewController,
                  superTransitionPerformer: AnyTransitionPerformer(superCoordinator),
                  prepareTransition: prepareTransition)
    }
}
