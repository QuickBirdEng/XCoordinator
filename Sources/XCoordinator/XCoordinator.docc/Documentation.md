# ``XCoordinator``

Type-safe, enum-driven navigation for UIKit and SwiftUI based on the Coordinator pattern.

## Overview

XCoordinator decouples navigation from view controllers and view models. You describe a flow as a `Route` enum, and a corresponding `Coordinator` decides which `Transition` to perform for each route. The result is reusable views, view models without navigation logic, and a single place to evolve the flow of your app.

XCoordinator is especially well-suited to MVVM-C (Model-View-ViewModel-Coordinator) and ships with first-class interop for both UIKit and SwiftUI.

For a longer prose introduction, motivation, and install instructions, see the [README on GitHub](https://github.com/quickbirdstudios/XCoordinator#readme).

## Getting started

Define a route enum and a coordinator that prepares a transition for each case:

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
    unowned let router: any Router<HomeRoute>

    init(router: any Router<HomeRoute>) {
        self.router = router
    }

    func usersButtonPressed() {
        router.trigger(.users)
    }
}
```

Bootstrap the initial coordinator from your app delegate or `@main` entry point, and hold it via a strong `any Router<AppRoute>`:

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

## Choosing a router reference

Since 3.0, type erasure is provided by Swift's parameterized existential `any Router<RouteType>`. There are no longer dedicated `AnyRouter`, `StrongRouter`, `UnownedRouter`, or `WeakRouter` types — you simply choose the ARC qualifier that matches the lifetime relationship:

```swift
let strongRouter: any Router<ExampleRoute> = ...               // own the coordinator
weak var weakRouter: (any Router<ExampleRoute>)? = ...         // sibling/parent reference
unowned let unownedRouter: any Router<ExampleRoute> = ...      // child holding parent
```

- **strong** — the app delegate or whatever object owns the coordinator's lifetime; also used to retain child coordinators.
- **weak** — view models or view controllers holding a coordinator they do not own (sibling or parent).
- **unowned** — same use case as weak, when you can guarantee the coordinator outlives the holder.

## SwiftUI interop

XCoordinator integrates with SwiftUI in two directions.

**Embed a coordinator-driven flow inside SwiftUI** with `WrappedRouter`. The closure builds the coordinator the first time the view appears; the coordinator instance is retained for the lifetime of the view:

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

**Trigger routes from inside a SwiftUI view** with the `@Routing` property wrapper. It reads the nearest router for the given route type from the environment:

```swift
struct ChildView: View {
    @Routing<UsersRoute> var usersRouter

    var body: some View {
        Button("Open") { usersRouter.trigger(.user("Bob")) }
    }
}
```

**Drive SwiftUI state changes from `prepareTransition`** with `Transition.withAnimation` or `Transition.withTransaction`, which run a body closure inside `SwiftUI.withAnimation`/`withTransaction` without performing any UIKit transition:

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

For declarative, condition-driven triggering, the `triggerOnAppear`, `triggerOnChange(of:)`, and `trigger(when:)` view modifiers let a SwiftUI view fire routes through `@Routing` automatically.

## Custom transitions

You can supply custom `Animation` objects to common transitions (`push`, `pop`, `present`, `dismiss`). Passing `nil` keeps the previously configured animation; `Animation.default` resets to UIKit defaults.

```swift
let animation = Animation(
    presentationAnimation: MyPresentation(),
    dismissalAnimation: MyDismissal()
)
return .push(viewController, animation: animation)
```

For interactive transitions driven by gesture recognizers, see ``BaseCoordinator/registerInteractiveTransition(for:triggeredBy:handler:completion:)`` and its progress-based overload.

## Deep linking

Chain routes across coordinator boundaries using `deepLink(_:_:)`. The deep link walks the coordinator tree via ``Presentable/router(for:)``, switching to whichever router can handle the next route type:

```swift
return deepLink(AppRoute.login, AppRoute.home, HomeRoute.news, HomeRoute.dismiss)
```

> Important: Deep links are not checked at compile time. If a router for one of the chained route types cannot be located at runtime, the framework triggers an `assertionFailure`. Keep this in mind whenever you reshape the coordinator hierarchy.

## RedirectionRouter

When a route enum has grown too large but you cannot introduce a new root view controller, ``RedirectionRouter`` lets you split a child route type onto a parent route type without owning its own transition type:

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

## Combine and RxSwift

The Combine extensions ship in the main `XCoordinator` module. Use `router.publishers.trigger(_:)` to obtain a `Future<Void, Never>` for a triggered route:

```swift
router.publishers.trigger(.home)
    .sink { /* transition finished */ }
```

For RxSwift, add the `XCoordinatorRx` product. The `router.rx.trigger(_:)` accessor returns a `Single<Void>`:

```swift
router.rx.trigger(.home)
    .flatMap { [unowned self] in self.router.rx.trigger(.news) }
```

## Transition types

The available transitions depend on the coordinator's `RootViewController` type. Common transitions across every coordinator:

- `present` / `presentOnRoot` — present on top of the view hierarchy
- `dismiss` / `dismissToRoot`
- `embed` — embed a view controller in a container view
- `none` — no-op (useful in tests or to ignore routes)

`NavigationTransition` (``NavigationCoordinator``) additionally provides `push`, `pop`, and `popToRoot`. ``TabBarCoordinator``, ``SplitCoordinator``, and ``PageCoordinator`` each provide transitions specific to their root view controller.

## Topics

### Coordinators

- ``Coordinator``
- ``BaseCoordinator``
- ``ViewCoordinator``
- ``NavigationCoordinator``
- ``TabBarCoordinator``
- ``SplitCoordinator``
- ``PageCoordinator``
- ``BasicCoordinator``
- ``RedirectionRouter``

### Routes and routing

- ``Route``
- ``Router``
- ``Presentable``
- ``TransitionPerformer``

### Transitions

- ``Transition``
- ``TransitionProtocol``
- ``TransitionOptions``
- ``NavigationTransition``
- ``TabBarTransition``
- ``SplitTransition``
- ``PageTransition``
- ``ViewTransition``

### Animations

- ``Animation``
- ``TransitionAnimation``
- ``StaticTransitionAnimation``
- ``InteractiveTransitionAnimation``
- ``InterruptibleTransitionAnimation``

### SwiftUI

- ``Routing``
- ``RoutingContext``
- ``RoutingContextProvider``
- ``RoutingController``
- ``WrappedRouter``
- ``RepresentableContext``
