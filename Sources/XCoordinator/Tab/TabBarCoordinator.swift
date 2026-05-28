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

    /// Internal animation delegate installed as the tab-bar controller's `delegate` when none was set.
    /// External callers should install their own delegate via the public ``delegate`` property.
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

    ///
    /// Creates a TabBarCoordinator and optionally triggers an initial route.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UITabBarController` to host transitions. Defaults to a fresh instance.
    ///   - initialRoute: A route to trigger once the coordinator is shown.
    ///
    public override init(rootViewController: RootViewController = .init(), initialRoute: RouteType?) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController, initialRoute: initialRoute)
    }

    ///
    /// Creates a TabBarCoordinator with a specified set of tabs.
    ///
    /// - Parameters:
    ///   - rootViewController: The `UITabBarController` to host transitions. Defaults to a fresh instance.
    ///   - tabs: The presentables to use as tabs.
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
    ///   - rootViewController: The `UITabBarController` to host transitions. Defaults to a fresh instance.
    ///   - tabs: The presentables to use as tabs.
    ///   - select: The presentable to select before displaying. Must be one of `tabs`.
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
    ///   - rootViewController: The `UITabBarController` to host transitions. Defaults to a fresh instance.
    ///   - tabs: The presentables to use as tabs.
    ///   - select: The index of the tab to select before displaying.
    ///
    public init(rootViewController: RootViewController = .init(), tabs: [Presentable], select: Int) {
        if rootViewController.delegate == nil {
            rootViewController.delegate = animationDelegate
        }
        super.init(rootViewController: rootViewController,
                   initialTransition: .multiple(.set(tabs), .select(index: select)))
    }
    
    #if canImport(Combine) && canImport(SwiftUI)

    ///
    /// Creates a tab bar coordinator whose selection is driven by a SwiftUI `Binding`.
    ///
    /// The `selection` binding stays in sync with the tab bar's selected item: external changes to
    /// the binding update the selected tab, and user-driven tab changes write back to the binding.
    ///
    /// - Parameters:
    ///   - rootViewController: The tab bar controller. Defaults to a fresh instance.
    ///   - items: The data items to render as tabs.
    ///   - selection: A binding to the currently selected item.
    ///   - content: A closure that builds a view controller for each item.
    ///
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
    
    ///
    /// Creates a tab bar coordinator whose selection is a `CaseIterable & Equatable` enum.
    ///
    /// Convenience over ``init(rootViewController:items:selection:content:)`` for enum-typed
    /// selections — the `items` are derived from `Item.allCases`.
    ///
    /// - Parameters:
    ///   - rootViewController: The tab bar controller. Defaults to a fresh instance.
    ///   - selection: A binding to the currently selected case.
    ///   - content: A closure that builds a view controller for each case.
    ///
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
