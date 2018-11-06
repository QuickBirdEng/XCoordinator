<p align="center">
  <img src="https://github.com/quickbirdstudios/RxCoordinator/blob/master/Images/logo.png">
</p>

[![Build Status](https://travis-ci.com/quickbirdstudios/RxCoordinator.svg?branch=master)](https://travis-ci.org/quickbirdstudios/RxCoordinator)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/rx-coordinator.svg)](https://img.shields.io/cocoapods/v/rx-coordinator.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](https://github.com/quickbirdstudios/RxCoordinator)
[![License](https://img.shields.io/cocoapods/l/AFNetworking.svg)](https://github.com/quickbirdstudios/RxCoordinator)

#
“How does an app transition from a ViewController to another?”.
This question is common and puzzling regarding iOS development. There are many answers, as every architecture has different implementation variations. Some do it from the view controller, while some do it using a router/coordinator, which is an object that connects view models.

To better answer the question, we are building **RxCoordinator**, a navigation framework based on the **Coordinator** pattern.
It's especially useful for implementing MVVM-C, Model-View-ViewModel-Coordinator:

<p align="center">
  <img src="https://github.com/quickbirdstudios/RxCoordinator/blob/master/Images/mvvmc.png">
</p>

## 🏃‍♂️Getting started

Create an enum with all of the navigation paths for a particular flow. (It is up to you when to create a `Route/Coordinator`, but as **our rule of thumb**, create a new `Route/Coordinator` whenever a new `navigation controller` is needed.)

```swift
enum HomeRoute: Route {
    case home
    case users
    case logout

    func prepareTransition(coordinator: AnyCoordinator<HomeRoute>) -> NavigationTransition {
        switch self {
        case .home:
            let viewModel = HomeViewModel(coodinator: coordinator)
            let vc = HomeViewController(viewModel: viewModel)
            return .push(vc)
        case .users:
            let viewModel = UsersViewModel(coodinator: coordinator)
            let vc = UsersViewController(viewModel: viewModel)
            return .push(vc)
        case .logout:
            return .dismiss()
        }
    }
}
```

Setup the root view controller in the AppDelegate.
```swift
  ...

    let basicCoordinator = BasicCoordinator<HomeRoute>(initialRoute: .home)

    func application(_ application:didFinishLaunchingWithOptions) -> Bool {
        window.rootViewController = basicCoordinator.navigationController

        return true
    }
```

Implementation:

```swift
    ...

    init(coodinator: AnyCoordinator<HomeRoute>) {
        self.coordinator = coodinator
    }

    func onUsersButtonPress() {
      self.coordinator.transition(to: .users)
    }

    ...
```

## 🤸‍♂️ Extras

### Custom Transitions
RxCoordinator supports cases for custom transitions between view controllers. In the `switch case` in `prepareTransition(coordinator:)` create an `Animation` while specifying your custom presentation transition or/and dismissal transition.

```swift
  ...
  func prepareTransition(coordinator: AnyCoordinator<HomeRoute>) -> Transition {
        switch self {
        ...

        case .users(let string):
            let animation = Animation(presentationAnimation: yourAnimation, dismissalAnimation: YourAwesomeDismissalTransitionAnimation())
            var vc = UsersViewController.instantiateFromNib()
            let viewModel = UsersViewModelImpl(coordinator: coordinator, string: string)
            vc.bind(to: viewModel)
            return .push(vc, animation: animation)
        ...
    }
```

### Custom Coordinators
In RxCoordinator is possible to create custom coordinators. For example, a custom coordinator can be created to show Home if the user is logged in, otherwise Login.

```swift

class AppCoordinator: Coordinator {
    typealias CoordinatorRoute = HomeRoute

    var context: UIViewController!
    var navigationController: UIViewController = UINavigationController()

    init() {}

    func presented(from presentable: Presentable?) {
        if isLoggedIn {
          transition(to: .home)
        } else {
          transition(to: .login)
        }
    }
}

```

## 🎭 Example
Check out this [repository](https://github.com/quickbirdstudios/RxCoordinator/tree/master/RxCoordinator-Example/RxCoordinator-Example) as an example project using RxCoordinator.


## 👨‍✈️ Why coordinators
* **Separation of responsibilities** by coordinator being the only component knowing anything related to the flow of your application.
* **Reusable Views and ViewModels** because they do not contain any navigation logic.
* **Less coupling between components**

* **Changeable navigation**: Each coordinator is only responsible for one component and makes no assumptions about its parent. It can therefore be placed wherever we want to.

> [The Coordinator](http://khanlou.com/2015/01/the-coordinator/) by **Soroush Khanlou**


## 💁‍♂️ Why RxCoordinator
* Actual **navigation code is already written** and abstracted away.

* Clear **separation of concerns**:
  - Coordinator: Coordinates routing of a set of routes.
  - Route: Describes navigation path.
  - Transition: Describe transition type and animation to new view.
* **Reuse** coordinators, routers and transitions in different combinations.
* Full support for **custom transitions/animations**.
* Support for **embedding child views** / container views.
* Provides **observables for presentation / dismissal** of views (E.g. block button until presentation is done).
* Generic BasicCoordinator class suitable for most use cases and therefore **less** need to write your **own coordinators**.
* Still full **support** for your **own coordinator classes** conforming to our Coordinator protocol.
* Generic AnyCoordinator type erasure class encapsulates all types of coordinators supporting the same set of routes. Therefore you can **easily replace coordinators**.
* Use of enum for routes gives you **autocompletion** and **type safety** to perform only transition to routes supported by the coordinator.

### Components

#### 🎢 Route
Describes a navigation path. Creates transition and loads view (and corresponding view model) with the help of the coordinator performing the transition.

#### 👨‍✈️ Coordinator
An object coordinating the transition to a set of routes pointing to views or other coordinators.

#### ✈️ Transition
Transitions describe the navigation from one view to another view.
  - ViewTransition: Supports basic transitions that every view controller supports
  - NavigationTransition: Adds navigation controller specific transitions

#### 🏗 Transition Types
Describes presentation/dismissal of a view including the type of the transition and the animation used.
  - present: present view controller.
  - embed: embed view controller to a container view.
  - dismiss: dismiss the view controller that was presented modally by the view controller.
  - none: does nothing to the view controller (allows you to handle case later without touching the ViewController)
  - push: push view controller to navigation stack. (only in `NavigationTransition`)
  - pop: pop the top view controller from the navigation stack and updates the display. (only in `NavigationTransition`)
  - popToRoot: pop all the view controllers on the navigation stack except the root view controller and updates the display. (only in `NavigationTransition`)

## 🛠 Installation

### CocoaPods

To integrate RxCoordinator into your Xcode project using CocoaPods, add this to your `Podfile`:

```ruby
pod 'rx-coordinator'
```

### Carthage

To integrate RxCoordinator into your Xcode project using Carthage, add this to your `Cartfile`:

```
github "quickbirdstudios/RxCoordinator" ~> 0.5
```

Then run `carthage update`.

If this is your first time using Carthage in the project, you'll need to go through some additional steps as explained [over at Carthage](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).

### Manually

If you prefer not to use any of the dependency managers, you can integrate RxCoordinator into your project manually, by downloading the source code and placing the files on your project directory.  
<br/><br/>
If you want more information on RxCoordinator check out this blog post: 
https://quickbirdstudios.com/blog/ios-navigation-library-based-on-the-coordinator-pattern/

## 👤 Author
This tiny library is created with ❤️ by [QuickBird Studios](www.quickbirdstudios.com).

## ❤️ Contributing
Open an issue if you need help, if you found a bug, or if you want to discuss a feature request.

Open a PR if you want to make some changes to RxCoordinator.

## 📃 License

RxCoordinator is released under an MIT license. See [License.md](https://github.com/quickbirdstudios/RxCoordinator/blob/master/LICENSE) for more information.
