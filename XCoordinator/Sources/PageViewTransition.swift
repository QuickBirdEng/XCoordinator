//
//  PageViewTransition.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//

public struct PageViewTransition: Transition {

    // MARK: - Stored properties

    let type: PageViewTransitionType

    // MARK: - Computed properties

    public var presentable: Presentable? {
        return type.presentable
    }

    // MARK: - Init

    private init(type: PageViewTransitionType) {
        self.type = type
    }

    internal init(type: PageViewTransitionType, animation: Animation?) {
        guard let animation = animation else {
            self.init(type: type)
            return
        }
        self.init(type: .animated(type, animation: animation))
    }

    // MARK: - Static functions

    public static func generateRootViewController() -> UIPageViewController {
        return UIPageViewController()
    }

    // MARK: - Methods

    public func perform<C>(options: TransitionOptions, coordinator: C, completion: PresentationHandler?) where PageViewTransition == C.TransitionType, C : Coordinator {
        type.perform(options: options, animation: nil, coordinator: coordinator, completion: completion)
    }
}


