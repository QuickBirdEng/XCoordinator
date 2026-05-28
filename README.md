<p align="center">
  <img src="https://user-images.githubusercontent.com/15239005/221913790-9c2b89fc-7497-49a1-9087-c3277f3ab4f2.png" alt="XCoordinator logo">
</p>

# XCoordinator

[![CI](https://github.com/quickbirdstudios/XCoordinator/actions/workflows/ci.yml/badge.svg)](https://github.com/quickbirdstudios/XCoordinator/actions/workflows/ci.yml)
[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platforms](https://img.shields.io/badge/platforms-iOS%2014%20%7C%20tvOS%2014-lightgrey.svg)](https://github.com/quickbirdstudios/XCoordinator)
[![SwiftPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![CocoaPods](https://img.shields.io/cocoapods/v/XCoordinator)](https://cocoapods.org/pods/XCoordinator)
[![License](https://img.shields.io/cocoapods/l/XCoordinator.svg)](LICENSE)

**Type-safe, enum-driven navigation for UIKit and SwiftUI based on the Coordinator pattern.**

XCoordinator decouples navigation from view controllers and view models: you describe a flow as a `Route` enum, and a `Coordinator` decides which `Transition` to perform for each route. The result is reusable views, view models without navigation logic, and a single place to evolve the flow of your app.

- 📚 **API reference** — [hosted DocC documentation](https://quickbirdstudios.github.io/XCoordinator/)
- 🧪 **Example app** — [XCoordinator-Example](https://github.com/quickbirdstudios/XCoordinator-Example) — a complete MVVM-C app using XCoordinator
- 🚀 **What's new in 3.0** — see [Migrating from 2.x to 3.0](#-migrating-from-2x-to-30) below

## Table of contents

- [Why XCoordinator](#-why-xcoordinator)
- [Getting started](#%EF%B8%8F-getting-started)
- [SwiftUI interop](#-swiftui-interop)
- [Choosing a router reference](#-choosing-a-router-reference)
- [Custom transitions](#-custom-transitions)
- [Deep linking](#-deep-linking)
- [RedirectionRouter](#-redirectionrouter)
- [Combine and RxSwift](#-combine-and-rxswift)
- [Migrating from 2.x to 3.0](#-migrating-from-2x-to-30)
- [Installation](#-installation)
- [Requirements](#-requirements)
- [Contributing](#%EF%B8%8F-contributing)

## 🤔 Why XCoordinator

- **Type-safe routes** — enums give you autocompletion and compile-time errors instead of stringly-typed paths.
- **One place for navigation** — view models trigger routes; the coordinator decides what each route does.
- **UIKit and SwiftUI** — a single coordinator can mix `UIViewController` flows with SwiftUI views via `RoutingController`, `WrappedRouter`, and `@Routing`.
- **Reusable** — coordinators, transitions, and animations compose; the same view model works inside different flows.
- **Custom transitions and deep linking** built in — interactive transitions, presentation animations, and route chains across coordinator boundaries.

<p align="center">
  <img src="https://user-images.githubusercontent.com/15239005/221913797-1ebf0fc8-36d5-4a93-b6da-0a86b6105e6a.png" alt="MVVM-C diagram showing how Coordinator connects View, ViewModel, and Model">
  <br><em>How Coordinator fits into MVVM</em>
</p>

## 🏃‍♂️ Getting started

Define a `Route` enum and a `Coordinator` that prepares a transition for each case:

```swift
enum UserListRoute: Route {
    case home
    case user(String)
    case logout
}

class UserListCoordinator: NavigationCoordinator<UserListRoute> {
    init() {
        super.init(initialRoute: .home)
    }

    override func prepareTransition(for route: UserListRoute) -> NavigationTransition {
        switch route {
        case .home:
            return .push(HomeViewController())
        case .user(let name):
            return .present(UserCoordinator(user: name), animation: .default)
        case .logout:
            return .dismiss()
        }
    }
}
```

Trigger routes from a view model that holds a typed router reference:

```swift
class HomeViewModel {
    unowned let router: any Router<UserListRoute>

    init(router: any Router<UserListRoute>) {
        self.router = router
    }

    func userButtonPressed(name: String) {
        router.trigger(.user(name))
    }
}
```

Bootstrap the initial coordinator from your app delegate or `@main` entry point — hold a strong `any Router<AppRoute>` to keep it alive:

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window: UIWindow! = UIWindow()
    let router: any Router<AppRoute> = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        router.setRoot(for: window)
        return true
    }
}
```

### How transitions compose

An app's structure is defined by nesting coordinators. Whenever your app changes flow (a new navigation stack, a new tab bar) introduce a new coordinator. Each coordinator owns a `rootViewController` (a `UINavigationController`, `UITabBarController`, etc.) that becomes the destination when another coordinator pushes or presents it.

## 🚀 SwiftUI interop

XCoordinator integrates with SwiftUI in two directions.

**Embed a coordinator inside SwiftUI** with `WrappedRouter`. The closure builds the coordinator on first appearance and the instance is retained for the lifetime of the view:

```swift
struct ContentView: View {
    var body: some View {
        WrappedRouter {
            UsersCoordinator()
        }
    }
}
```

**Push or present a SwiftUI view from a UIKit coordinator** with `RoutingController`, a `UIHostingController` subclass that propagates the current `RoutingContext` into the SwiftUI environment:

```swift
class UsersCoordinator: NavigationCoordinator<UserRoute> {
    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case .user(let name):
            return .push(RoutingController { UserView(name: name) })
        }
    }
}
```

**Trigger routes from inside a SwiftUI view** with `@Routing`:

```swift
struct ChildView: View {
    @Routing<UsersRoute> var usersRouter

    var body: some View {
        Button("Open") {
            usersRouter.trigger(.user("Bob"))
        }
    }
}
```

**Drive SwiftUI state changes from `prepareTransition`** without performing a UIKit transition — use `Transition.withAnimation` or `Transition.withTransaction`:

```swift
class HomeCoordinator: TabBarCoordinator<HomeRoute> {
    @Binding var selection: HomeTab

    override func prepareTransition(for route: HomeRoute) -> TabBarTransition {
        switch route {
        case .select(let tab):
            return .withAnimation { selection = tab }
        }
    }
}
```

For declarative triggering, `triggerOnAppear`, `triggerOnChange(of:)`, and `trigger(when:)` view modifiers fire routes through `@Routing` automatically.

## 🧭 Choosing a router reference

Since 3.0, type erasure is provided by Swift's parameterized existential `any Router<RouteType>`. The previously dedicated `AnyRouter`, `StrongRouter`, `UnownedRouter`, and `WeakRouter` types are gone. Pick the ARC qualifier that matches the relationship:

```swift
let strongRouter: any Router<ExampleRoute> = ...               // own the coordinator
weak var weakRouter: (any Router<ExampleRoute>)? = ...         // sibling/parent reference
unowned let unownedRouter: any Router<ExampleRoute> = ...      // child holding parent
```

- **strong** — the app delegate or whatever object owns the coordinator's lifetime; also used to hold child coordinators.
- **weak** — view models or view controllers referring to a sibling or parent coordinator.
- **unowned** — same use case as weak when the holder is guaranteed not to outlive the coordinator.

## 🌗 Custom transitions

Pass a custom `Animation` to common transitions (`push`, `pop`, `present`, `dismiss`). Pass `nil` to keep the previously configured animation; pass `Animation.default` to reset to UIKit defaults.

```swift
override func prepareTransition(for route: UserRoute) -> NavigationTransition {
    switch route {
    case .user(let name):
        let animation = Animation(
            presentationAnimation: YourAwesomePresentationTransitionAnimation(),
            dismissalAnimation: YourAwesomeDismissalTransitionAnimation()
        )
        return .push(UserViewController(name: name), animation: animation)
    }
}
```

For interactive transitions driven by gesture recognizers, see `BaseCoordinator.registerInteractiveTransition(for:triggeredBy:handler:completion:)` and its progress-based overload.

## 🛤 Deep linking

> [!IMPORTANT]
> Deep links are not validated at compile time. If a router for one of the chained route types cannot be located at runtime, XCoordinator calls `assertionFailure`. Be careful when reshaping your coordinator hierarchy.

Chain routes across coordinator boundaries using `deepLink(_:_:)`. The deep link walks the coordinator tree, switching to whichever router can handle the next route type:

```swift
override func prepareTransition(for route: AppRoute) -> NavigationTransition {
    switch route {
    case .deep:
        return deepLink(AppRoute.login, AppRoute.home, HomeRoute.news, HomeRoute.dismiss)
    }
}
```

## 🚏 RedirectionRouter

When a route enum has grown too large but you cannot introduce a new root view controller, `RedirectionRouter` lets you split a child route type onto a parent route type without owning its own transition type:

```swift
class ChildCoordinator: RedirectionRouter<ParentRoute, ChildRoute> {
    init(parent: any Router<ParentRoute>) {
        super.init(viewController: UIViewController(), parent: parent, map: nil)
    }

    override func mapToParentRoute(for route: ChildRoute) -> ParentRoute {
        // map ChildRoute cases onto ParentRoute cases
    }
}
```

Alternatively, two sibling coordinators can share the same `rootViewController` by passing it into the second coordinator's initializer.

## 🔀 Combine and RxSwift

The Combine extensions are built into the main `XCoordinator` module. Use `router.publishers.trigger(_:)` to obtain a `Future<Void, Never>` for a triggered route:

```swift
router.publishers.trigger(.home)
    .sink { /* transition finished */ }
```

For RxSwift, add the `XCoordinatorRx` product. The `router.rx.trigger(_:)` accessor returns an `Observable<Void>`:

```swift
router.rx.trigger(.home)
    .flatMap { [unowned self] in self.router.rx.trigger(.news) }
```

## ⬆️ Migrating from 2.x to 3.0

3.0 removes the type-erased router wrappers and folds Combine into the main module. Migration is mechanical:

| 2.x | 3.0 |
| --- | --- |
| `AnyRouter<Route>` | `any Router<Route>` |
| `StrongRouter<Route>` | `any Router<Route>` |
| `WeakRouter<Route>` | `weak var router: (any Router<Route>)?` |
| `UnownedRouter<Route>` | `unowned let router: any Router<Route>` |
| `coordinator.unownedRouter` | pass `self` directly or capture explicitly |
| `pod 'XCoordinator/Combine'` | the Combine extensions are bundled into `XCoordinator` |

The SwiftUI interop layer (`RoutingController`, `WrappedRouter`, `@Routing`, `Transition.withAnimation`, …) is new in 3.0 — see [SwiftUI interop](#-swiftui-interop).

## 🛠 Installation

### Swift Package Manager (recommended)

Add the package to your `Package.swift`:

```swift
.package(url: "https://github.com/quickbirdstudios/XCoordinator.git", from: "3.0.0")
```

Then add the product you need to your target's dependencies — either `XCoordinator` (core + Combine + SwiftUI) or `XCoordinatorRx` (adds RxSwift).

In Xcode, use **File → Add Package Dependencies** and paste the same URL.

### CocoaPods

```ruby
pod 'XCoordinator', '~> 3.0'
```

For RxSwift bindings:

```ruby
pod 'XCoordinator/RxSwift', '~> 3.0'
```

Combine is bundled into the main pod; no separate subspec is needed.

### Carthage

```
github "quickbirdstudios/XCoordinator" ~> 3.0
```

## ✅ Requirements

- iOS 14 / tvOS 14
- Swift 5.9
- Xcode 15

## ❤️ Contributing

- Open an [issue](https://github.com/quickbirdstudios/XCoordinator/issues) if you found a bug, want to discuss a feature request, or need help.
- Use [GitHub Discussions](https://github.com/quickbirdstudios/XCoordinator/discussions) for usage questions.
- Open a [pull request](https://github.com/quickbirdstudios/XCoordinator/pulls) if you want to contribute a change — please include tests where applicable.

XCoordinator is created and maintained by [QuickBird Studios](https://quickbirdstudios.com).

## 📃 License

XCoordinator is released under the MIT License. See [LICENSE](LICENSE) for more information.
