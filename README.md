<p align="center">
  <img src="https://quickbirdstudios.com/files/xcoordinator/logo.png">
</p>

# [![Build Status](https://travis-ci.com/quickbirdstudios/XCoordinator.svg?branch=master)](https://travis-ci.com/quickbirdstudios/XCoordinator) [![CocoaPods Compatible](https://img.shields.io/cocoapods/v/XCoordinator.svg)](https://cocoapods.org/pods/XCoordinator) [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Documentation](https://img.shields.io/badge/documentation-100%25-brightgreen)](https://quickbirdstudios.github.io/XCoordinator) [![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://github.com/quickbirdstudios/XCoordinator) [![License](https://img.shields.io/cocoapods/l/XCoordinator.svg)](https://github.com/quickbirdstudios/XCoordinator/blob/master/LICENSE)

⚠️ We have recently released XCoordinator 2.0. Make sure to read [this section](#when-to-use-which-router-abstraction) before migrating. In general, please replace all `AnyRouter` by either `UnownedRouter` (in viewControllers, viewModels or references to parent coordinators) or `StrongRouter` in your `AppDelegate` or for references to child coordinators. In addition to that, the rootViewController is now injected into the initializer instead of being created in the `Coordinator.generateRootViewController` method.

“How does an app transition from one view controller to another?”.
This question is common and puzzling regarding iOS development. There are many answers, as every architecture has different implementation variations. Some do it from within the implementation of a view controller, while some use a router/coordinator, an object connecting view models.

To better answer the question, we are building **XCoordinator**, a navigation framework based on the **Coordinator** pattern.
It's especially useful for implementing MVVM-C, Model-View-ViewModel-Coordinator:

<p align="center">
  <img src="https://quickbirdstudios.com/files/xcoordinator/mvvmc.png">
</p>

## 🏃‍♂️Getting started

Create an enum with all of the navigation paths for a particular flow, i.e. a group of closely connected scenes. (It is up to you when to create a `Route/Coordinator`. As **our rule of thumb**, create a new `Route/Coordinator` whenever a new root view controller, e.g. a new `navigation controller` or a `tab bar controller`, is needed.).

Whereas the `Route` describes which routes can be triggered in a flow, the `Coordinator` is responsible for the preparation of transitions based on routes being triggered. We could, therefore, prepare multiple coordinators for the same route, which differ in which transitions are executed for each route.

In the following example, we create the `UserListRoute` enum to define triggers of a flow of our application. `UserListRoute` offers routes to open the home screen, display a list of users, to open a specific user and to log out. The `UserListCoordinator` is implemented to prepare transitions for the triggered routes. When a `UserListCoordinator` is shown, it triggers the `.home` route to display a `HomeViewController`.

```swift
enum UserListRoute: Route {
    case home
    case users
    case user(String)
    case registerUsersPeek(from: Container)
    case logout
}

class UserListCoordinator: NavigationCoordinator<UserListRoute> {
    init() {
        super.init(initialRoute: .home)
    }

    override func prepareTransition(for route: UserListRoute) -> NavigationTransition {
        switch route {
        case .home:
            let viewController = HomeViewController.instantiateFromNib()
            let viewModel = HomeViewModelImpl(router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController)
        case .users:
            let viewController = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController, animation: .interactiveFade)
        case .user(let username):
            let coordinator = UserCoordinator(user: username)
            return .present(coordinator, animation: .default)
        case .registerUsersPeek(let source):
            return registerPeek(for: source, route: .users)
        case .logout:
            return .dismiss()
        }
    }
}
```

Routes are triggered from within Coordinators or ViewModels. In the following, we describe how to trigger routes from within a ViewModel. The router of the current flow is injected into the ViewModel.

```swift
class HomeViewModel {
    let router: UnownedRouter<HomeRoute>

    init(router: UnownedRouter<HomeRoute>) {
        self.router = router
    }

    /* ... */

    func usersButtonPressed() {
        router.trigger(.users)
    }
}
```

### 🏗 Organizing an app's structure with XCoordinator

In general, an app's structure is defined by nesting coordinators and view controllers. You can transition (i.e. `push`, `present`, `pop`, `dismiss`) to a different coordinator whenever your app changes to a different flow. Within a flow, we transition between viewControllers.

Example: In `UserListCoordinator.prepareTransition(for:)` we change from the `UserListRoute` to the `UserRoute` whenever the `UserListRoute.user` route is triggered. By dismissing a viewController in `UserListRoute.logout`, we additionally switch back to the previous flow - in this case the `HomeRoute`.

To achieve this behavior, every Coordinator has its own `rootViewController`. This would be a `UINavigationController` in the case of a `NavigationCoordinator`, a `UITabBarController` in the case of a `TabBarCoordinator`, etc. When transitioning to a Coordinator/Router, this `rootViewController` is used as the destination view controller.

### 🏁 Using XCoordinator from App Launch

To use coordinators from the launch of the app, make sure to create the app's `window` programmatically in `AppDelegate.swift` (Don't forget to remove `Main Storyboard file base name` from `Info.plist`). Then, set the coordinator as the root of the `window`'s view hierarchy in the `AppDelegate.didFinishLaunching`. Make sure to hold a strong reference to your app's initial coordinator or a `strongRouter` reference.

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window: UIWindow! = UIWindow()
    let router = AppCoordinator().strongRouter

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        router.setRoot(for: window)
        return true
    }
}
```

## 🤸‍♂️ Extras

For more advanced use, XCoordinator offers many more customization options. We introduce custom animated transitions and deep linking. Furthermore, extensions for use in reactive programming with RxSwift/Combine and options to split up huge routes are described.

### 🌗 Custom Transitions

Custom animated transitions define presentation and dismissal animations. You can specify `Animation` objects in `prepareTransition(for:)` in your coordinator for several common transitions, such as `present`, `dismiss`, `push` and `pop`. Specifying no animation (`nil`) results in not overriding previously set animations. Use `Animation.default` to reset previously set animation to the default animations UIKit offers.

```swift
class UsersCoordinator: NavigationCoordinator<UserRoute> {

    /* ... */
    
    override func prepareTransition(for route: UserRoute) -> NavigationTransition {
        switch route {
        case .user(let name):
            let animation = Animation(
                presentationAnimation: YourAwesomePresentationTransitionAnimation(),
                dismissalAnimation: YourAwesomeDismissalTransitionAnimation()
            )
            let viewController = UserViewController.instantiateFromNib()
            let viewModel = UserViewModelImpl(name: name, router: unownedRouter)
            viewController.bind(to: viewModel)
            return .push(viewController, animation: animation)
        /* ... */
        }
    }
}
```

### 🛤 Deep Linking

Deep Linking can be used to chain different routes together. In contrast to the `.multiple` transition, deep linking can identify routers based on previous transitions (e.g. when pushing or presenting a router), which enables chaining of routes of different types. Keep in mind, that you cannot access higher-level routers anymore once you trigger a route on a lower level of the router hierarchy.

```swift
class AppCoordinator: NavigationCoordinator<AppRoute> {

    /* ... */

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        /* ... */
        case .deep:
            return deepLink(AppRoute.login, AppRoute.home, HomeRoute.news, HomeRoute.dismiss)
        }
    }
}
```

⚠️ XCoordinator does not check at compile-time, whether a deep link can be executed. Rather it uses assertionFailures to inform about incorrect chaining at runtime, when it cannot find an appriopriate router for a given route. Keep this in mind when changing the structure of your app.

### 🚏 RedirectionRouter

Let's assume, there is a route type called `HugeRoute` with more than 10 routes. To decrease coupling, `HugeRoute` needs to be split up into mutliple route types. As you will discover, many routes in `HugeRoute` use transitions dependent on a specific rootViewController, such as `push`, `show`, `pop`, etc. If splitting up routes by introducing a new router/coordinator is not an option, XCoordinator has two solutions for you to solve such a case: `RedirectionRouter` or using multiple coordinators with the same rootViewController ([see this section for more information](#using-multiple-coordinators-with-the-same-rootviewcontroller)).

A `RedirectionRouter` can be used to map a new route type onto a generalized `ParentRoute`. A `RedirectionRouter` is independent of the `TransitionType` of its parent router. You can use `RedirectionRouter.init(viewController:parent:map:)` or subclassing by overriding `mapToParentRoute(_:)` to create a `RedirectionRouter`.

The following code example illustrates how a `RedirectionRouter` is initialized and used.

```swift
class ParentCoordinator: NavigationCoordinator<ParentRoute> {
    /* ... */
    
    override func prepareTransition(for route: ParentRoute) -> NavigationTransition {
        switch route {
        /* ... */
        case .child:
            let childCoordinator = ChildCoordinator(parent: unownedRouter)
            return .push(childCoordinator)
        }
    }
}

class ChildCoordinator: RedirectionRouter<ParentRoute, ChildRoute> {
    init(parent: UnownedRouter<ParentRoute>) {
        let viewController = UIViewController() 
        // this viewController is used when performing transitions with the Subcoordinator directly.
        super.init(viewController: viewController, parent: parent, map: nil)
    }
    
    /* ... */
    
    override func mapToParentRoute(for route: ChildRoute) -> ParentRoute {
        // you can map your ChildRoute enum to ParentRoute cases here that will get triggered on the parent router.
    }
}
```

### 🚏Using multiple coordinators with the same rootViewController

With XCoordinator 2.0, we introduce the option to use different coordinators with the same rootViewController.
Since you can specify the rootViewController in the initializer of a new coordinator, you can specify an existing coordinator's rootViewController as in the following:

```swift
class FirstCoordinator: NavigationCoordinator<FirstRoute> {
    /* ... */
    
    override func prepareTransition(for route: FirstRoute) -> NavigationTransition {
        switch route {
        case .secondCoordinator:
            let secondCoordinator = SecondCoordinator(rootViewController: self.rootViewController)
            addChild(secondCoordinator)
            return .none() 
            // you could also trigger a specific initial route at this point, 
            // such as `.trigger(SecondRoute.initial, on: secondCoordinator)`
        }
    }
}
```

We suggest to not use initial routes in the initializers of sibling coordinators, but instead using the transition option in the `FirstCoordinator` instead. 

⚠️ If you perform transitions involving a sibling coordinator directly (e.g. pushing a sibling coordinator without overriding its `viewController` property), your app will most likely crash.

### 🚀 RxSwift/Combine extensions

Reactive programming can be very useful to keep the state of view and model consistent in a MVVM architecture. Instead of relying on the completion handler of the `trigger` method available in any `Router`, you can also use our RxSwift-extension. In the example application, we use Actions (from the [Action](https://github.com/RxSwiftCommunity/Action) framework) to trigger routes on certain UI events - e.g. to trigger `LoginRoute.home` in `LoginViewModel`, when the login button is tapped.

```swift
class LoginViewModelImpl: LoginViewModel, LoginViewModelInput, LoginViewModelOutput {

    private let router: UnownedRouter<AppRoute>

    private lazy var loginAction = CocoaAction { [unowned self] in
        return self.router.rx.trigger(.home)
    }

    /* ... */
}

```

In addition to the above-mentioned approach, the reactive `trigger` extension can also be used to sequence different transitions by using the `flatMap` operator, as can be seen in the following:

```swift
let doneWithBothTransitions = 
    router.rx.trigger(.home)
        .flatMap { [unowned self] in self.router.rx.trigger(.news) }
        .map { true }
        .startWith(false)
```

When using `XCoordinator` with the `Combine` extensions, you can use `router.publishers.trigger` instead of `router.rx.trigger`.

## 📚 Documentation & Example app

To get more information about XCoordinator, check out the [documentation](https://quickbirdstudios.github.io/XCoordinator).
Additionally, this [repository](https://github.com/quickbirdstudios/XCoordinator-Example) serves as an example project using a MVVM architecture with XCoordinator.

For a MVC example app, have a look at [some presentations](https://github.com/quickbirdstudios/XCoordinator-Talks) we did about the Coordinator pattern and XCoordinator.

## 👨‍✈️ Why coordinators

* **Separation of responsibilities** with the coordinator being the only component knowing anything related to the flow of your application.
* **Reusable Views and ViewModels** because they do not contain any navigation logic.
* **Less coupling between components**

* **Changeable navigation**: Each coordinator is only responsible for one component and does not need to make assumptions about its parent. It can therefore be placed wherever we want to.

> [The Coordinator](http://khanlou.com/2015/01/the-coordinator/) by **Soroush Khanlou**


## ⁉️ Why XCoordinator

* Actual **navigation code is already written** and abstracted away.
* Clear **separation of concerns**:
  - Coordinator: Coordinates routing of a set of routes.
  - Route: Describes navigation path.
  - Transition: Describe transition type and animation to new view.
* **Reuse** coordinators, routers and transitions in different combinations.
* Full support for **custom transitions/animations**.
* Support for **embedding child views** / container views.
* Generic `BasicCoordinator` classes suitable for many use cases and therefore **less** need to write your **own coordinators**.
* Full **support** for your **own coordinator classes** conforming to our Coordinator protocol
  - You can also start with one of the following types to get a head start: `NavigationCoordinator`, `ViewCoordinator`, `TabBarCoordinator` and more.
* Generic AnyRouter type erasure class encapsulates all types of coordinators and routers supporting the same set of routes. Therefore you can **easily replace coordinators**.
* Use of enum for routes gives you **autocompletion** and **type safety** to perform only transition to routes supported by the coordinator.

## 🔩 Components

### 🎢 Route

Describes possible navigation paths within a flow, a collection of closely related scenes.

### 👨‍✈️ Coordinator / Router

An object loading views and creating viewModels based on triggered routes. A Coordinator creates and performs transitions to these scenes based on the data transferred via the route. In contrast to the coordinator, a router can be seen as an abstraction from that concept limited to triggering routes. Often, a Router is used to abstract from a specific coordinator in ViewModels.

#### When to use which Router abstraction

You can create different router abstractions using the `unownedRouter`, `weakRouter` or `strongRouter` properties of your `Coordinator`.
You can decide between the following router abstractions of your coordinator:

- **StrongRouter** holds a strong reference to the original coordinator. You can use this to hold child coordinators or to specify a certain router in the `AppDelegate`.
- **WeakRouter** holds a weak reference to the original coordinator. You can use this to hold a coordinator in a viewController or viewModel. It can also be used to keep a reference to a sibling or parent coordinator. 
- **UnownedRouter** holds an unowned reference to the original coordinator. You can use this to hold a coordinator in a viewController or viewModel. It can also be used to keep a reference to a sibling or parent coordinator.

If you want to know more about the differences on how references can be held, have a look [here](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html).

### 🌗 Transition

Transitions describe the navigation from one view to another. Transitions are available based on the type of the root view controller in use. Example: Whereas `ViewTransition` only supports basic transitions that every root view controller supports, `NavigationTransition` adds navigation controller specific transitions.

The available transition types include:
  - **present** presents a view controller on top of the view hierarchy - use **presentOnRoot** in case you want to present from the root view controller
  - **embed** embeds a view controller into a container view
  - **dismiss** dismisses the top most presented view controller - use **dismissToRoot** to call dismiss on the root view controller
  - **none** does nothing, may be used to ignore routes or for testing purposes
  - **push** pushes a view controller to the navigation stack (only in `NavigationTransition`)
  - **pop** pops the top view controller from the navigation stack (only in `NavigationTransition`)
  - **popToRoot** pops all the view controllers on the navigation stack except the root view controller (only in `NavigationTransition`)
  
  XCoordinator additionally supports common transitions for `UITabBarController`, `UISplitViewController` and `UIPageViewController` root view controllers.

## 🛠 Installation

#### CocoaPods

To integrate XCoordinator into your Xcode project using CocoaPods, add this to your `Podfile`:

```ruby
pod 'XCoordinator', '~> 2.0'
```

To use the RxSwift extensions, add this to your `Podfile`:

```ruby
pod 'XCoordinator/RxSwift', '~> 2.0'
```

To use the Combine extensions, add this to your `Podfile`:

```ruby
pod 'XCoordinator/Combine', '~> 2.0'
```

#### Carthage

To integrate XCoordinator into your Xcode project using Carthage, add this to your `Cartfile`:

```
github "quickbirdstudios/XCoordinator" ~> 2.0
```

Then run `carthage update`.

If this is your first time using Carthage in the project, you'll need to go through some additional steps as explained [over at Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

#### Swift Package Manager

See [this WWDC presentation](https://developer.apple.com/videos/play/wwdc2019/408/) about more information how to adopt Swift packages in your app.

Specify `https://github.com/quickbirdstudios/XCoordinator.git` as the `XCoordinator` package link. 
You can then decide between three different frameworks, i.e. `XCoordinator`, `XCoordinatorRx` and `XCoordinatorCombine`. 
While `XCoordinator` contains the main framework, you can choose `XCoordinatorRx` or `XCoordinatorCombine` to get `RxSwift` or `Combine` extensions as well.

#### Manually

If you prefer not to use any of the dependency managers, you can integrate XCoordinator into your project manually, by downloading the source code and placing the files on your project directory.  

## 👤 Author
This framework is created with ❤️ by [QuickBird Studios](https://quickbirdstudios.com).

To get more information on XCoordinator check out [our blog post](https://quickbirdstudios.com/blog/ios-navigation-library-based-on-the-coordinator-pattern/).

## ❤️ Contributing

Open an issue if you need help, if you found a bug, or if you want to discuss a feature request. If you feel like having a chat about XCoordinator with the developers and other users, join our [Slack Workspace](https://join.slack.com/t/xcoordinator/shared_invite/enQtNDg4NDAxNTk1ODQ1LTkxYzE3MDM5ZGY1MTVmY2NhNjI0Y2JiYmQ5NTdjZDczZDRjZTg1ZmJlOTZmODYyYzMyYWQ0NzhlNGNkMGIzYjQ).

Open a PR if you want to make changes to XCoordinator.

## 📃 License

XCoordinator is released under an MIT license. See [License.md](https://github.com/quickbirdstudios/XCoordinator/blob/master/LICENSE) for more information.
