//
//  TabBarCoordinator.swift
//  XCoordinator
//
//  Created by Paul Kraft on 29.07.18.
//  Copyright © 2018 QuickBird Studios. All rights reserved.
//

#if canImport(Combine) && canImport(SwiftUI)

import Combine
import SwiftUI

#endif

import UIKit

///
/// Use a TabBarCoordinator to coordinate a flow where a `UITabbarController` serves as a rootViewController.
/// With a TabBarCoordinator, you get access to all tabbarController-related transitions.
///
open class TabBarCoordinator<RouteType: Route>: BaseCoordinator<RouteType, TabBarTransition> {

    // MARK: Stored properties

    ///
    /// The animation delegate controlling the rootViewController's transition animations.
    /// This animation delegate is set to be the rootViewController's rootViewController, if you did not set one earlier.
    ///
    /// - Note:
    ///     Use the `delegate` property to set a custom delegate and use transition animations provided by XCoordinator.
    ///
    private let animationDelegate = TabBarAnimationDelegate()
    // swiftlint:disable:previous weak_delegate
    
    internal var strongReferences = [Any]()

    // MARK: Computed properties

    ///
    /// Use this delegate to get informed about tabbarController-related notifications and delegate methods
    /// specifying transition animations. The delegate is only referenced weakly.
    ///
    /// Set this delegate instead of overriding the delegate of the rootViewController
    /// specified in the initializer, if possible, to allow for transition animations
    /// to be executed as specified in the `prepareTransition(for:)` method.
    ///
    public var delegate: UITabBarControllerDelegate? {
        get {
            animationDelegate.delegate
        }
        set {
            animationDelegate.delegate = newValue
        }
    }

    // MARK: Initialization

    public override init(rootViewController: RootViewController = .init(), initialRoute: RouteType?) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
    }

    ///
    /// Creates a TabBarCoordinator with a specified set of tabs.
    ///
    /// - Parameter tabs:
    ///     The presentables to be used as tabs.
    ///
    public init(rootViewController: RootViewController = .init(), tabs: [Presentable]) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialTransition: .set(tabs))
    }

    ///
    /// Creates a TabBarCoordinator with a specified set of tabs and selects a specific presentable.
    ///
    /// - Parameters:
    ///     - tabs: The presentables to be used as tabs.
    ///     - select:
    ///         The presentable to be selected before displaying. Make sure, this presentable is one of the
    ///         specified tabs in the other parameter.
    ///
    public init(rootViewController: RootViewController = .init(), tabs: [Presentable], select: Presentable) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController,
                   initialTransition: .multiple(.set(tabs), .select(select)))
    }

    ///
    /// Creates a TabBarCoordinator with a specified set of tabs and selects a presentable at a given index.
    ///
    /// - Parameters:
    ///     - tabs: The presentables to be used as tabs.
    ///     - select: The index of the presentable to be selected before displaying.
    ///
    public init(rootViewController: RootViewController = .init(), tabs: [Presentable], select: Int) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController,
                   initialTransition: .multiple(.set(tabs), .select(index: select)))
    }
    
    #if canImport(Combine) && canImport(SwiftUI)

    @available(iOS 13, tvOS 13, *)
    public init<Items: Collection>(
        rootViewController: RootViewController = .init(),
        items: Items,
        selection: Binding<Items.Element>,
        content: (Items.Element) -> UIViewController
    ) where Items.Index == Int, Items.Element: Equatable {
        let tabs = items.map(content)
        let selectedTab = tabs[items.firstIndex(of: selection.wrappedValue) ?? 0]
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController,
                   initialTransition: .multiple(.set(tabs), .select(selectedTab)))
        
        let cancellable = Publishers.Merge(
                rootViewController
                    .publisher(for: \.selectedViewController)
                    .compactMap { [weak self] _ in self?.rootViewController.selectedIndex },
                rootViewController
                    .publisher(for: \.selectedIndex)
            )
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { selection.wrappedValue = items[$0] }
        strongReferences.append(cancellable)
    }
    
    @available(iOS 13, tvOS 13, *)
    public init<Item: CaseIterable & Equatable>(
        rootViewController: RootViewController = .init(),
        selection: Binding<Item>,
        content: (Item) -> UIViewController
    ) where Item.AllCases.Index == Int {
        let tabs = Item.allCases.map(content)
        let selectedTab = tabs[Item.allCases.firstIndex(of: selection.wrappedValue) ?? 0]
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController,
                   initialTransition: .multiple(.set(tabs), .select(selectedTab)))
        
        let cancellable = Publishers.Merge(
                rootViewController
                    .publisher(for: \.selectedViewController)
                    .compactMap { [weak self] _ in self?.rootViewController.selectedIndex },
                rootViewController
                    .publisher(for: \.selectedIndex)
            )
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { selection.wrappedValue = Item.allCases[$0] }
        strongReferences.append(cancellable)
    }
    #endif

}
