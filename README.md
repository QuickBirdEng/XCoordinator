<p align="center">
  <img src="https://github.com/jdisho/RxCoordinator/blob/master/Images/munich.png">
</p>

##  Why coordinators:
* **Separation of responsibilities** by coordinator being only component knowing anything related to the flow of your application
* **Reusable View ands ViewModels** because the don't contain any navigation logic
* **Less coupling between components**
* **Changeable navigation**: Each coordinator is only responsible for one component and makes no assumptions about its parent. It can therefore be placed wherever we want to.

> [The Coordinator](http://khanlou.com/2015/01/the-coordinator/) by **Soroush Khanlou**

## ⛵️ What is RxCoordinator
* Actual **navigation code is already written** and abstracted away

* Clear **separation of concerns**:
  - Coordinator: Coordinates routing of a set of routes
  - Route: Describes navigation path
  - Transition: Describe transition type and animation to new view
* **Reuse** coordinators, routers and transitions in different combinations
* Full support for **custom transitions/animations**
* Support for **embedding child views** / container views
* Provides **observables for presentation / dismissal** of views (E.g. block button until presentation is done)
* Generic BasicCoordinator class suitable for most use cases and therefore **less** need to write your **own coordinators**
* Still full **support** for your **own coordinator classes** conforming to our Coordinator protocol
* Generic AnyCoordinator type erasure class encapsulates all types of coordinators supporting the same set of routes. Therefor you can **easily replace coordinators**
* Use of enum for routes gives you **autocompletion** and **type safety** to perform only transition to routes supported by the coordinator.

### Components

### 🎢 Route
Describes a navigation path. Creates transition and loads View (and corresponding ViewModel) with the help of the coordinator performing the transition.

#### 👨‍✈️ Coordinator
An object coordinating the transition to a set of routes pointing to views or other coordinators.

#### 🏗 Transition Types
Describes presentation/dismissal of a view including the type of the transition and the animation used.
  - push: push view controller to navigation stack.
  - present: present view controller.
  - embed: embed view controller to a container view.
  - pop: pop the top view controller from the navigation stack and updates the display.
  - popToRoot: pop all the view controllers on the navigation stack except the root view controller and updates the display.
  - dismiss: dismissthe view controller that was presented modally by the view controller.
  - none: does nothing to the view controller

## 🛠 Installation

### CocoaPods

To integrate RxCoordinator into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'rx-coordinator'
```

### Manually

If you prefer not to use any of the dependency managers, you can integrate RxCoordinator into your project manually, by downloading the source code and placing the files on your project directory.

## 👨🏻‍💻 Usage


