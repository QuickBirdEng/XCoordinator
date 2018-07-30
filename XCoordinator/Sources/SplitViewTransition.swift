//
//  SplitViewTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//

public struct SplitViewTransition: Transition {

    // MARK: - Stored properties

    let type: SplitViewTransitionType

    // MARK: - Computed properties

    public var presentable: Presentable? {
        return type.presentable
    }

    // MARK: - Init

    private init(type: SplitViewTransitionType) {
        self.type = type
    }

    internal init(type: SplitViewTransitionType, animation: Animation?) {
        guard let animation = animation else {
            self.init(type: type)
            return
        }
        self.init(type: .animated(type, animation: animation))
    }

    // MARK: - Static functions

    public static func generateRootViewController() -> UISplitViewController {
        return UISplitViewController()
    }

    // MARK: - Methods

    public func perform<C>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where SplitViewTransition == C.TransitionType, C : Coordinator {
        type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
}

extension SplitViewTransition {
    public static func multiple(_ transitions: [SplitViewTransition], completion: PresentationHandler?) -> SplitViewTransition {
        return SplitViewTransition(type: .multiple(transitions.map { $0.type }), animation: nil)
    }

    static func multiple(_ transitions: [SplitViewTransitionType]) -> SplitViewTransition {
        return SplitViewTransition(type: .multiple(transitions), animation: nil)
    }
}
