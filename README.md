<p align="center">
  <img src="https://github.com/jdisho/RxCoordinator/blob/master/Images/munich.png">
</p>


## 👨‍✈️ Coordinator
>  A coordinator is an object that bosses one or more view controllers around. Taking all of the driving logic out of your view controllers, and moving that stuff one layer up. 
>
> Soroush Khanlou [Coordinators Redux](http://khanlou.com/2015/10/coordinators-redux/)

## ⛵️ What is RxCoordinator
RxCoordinator is a lightweight navigation framework based on coordinator pattern.

Allowing to remove the navigation code from `UIViewControllers`, reusing `UIViewControllers` in different contexts and providing ease the use of **dependency injection**.

### Components

#### 📲 Scene
Refers to a screen managed by a view controller together with the transition type. It can be a regular screen, a modal dialog or a coordinator.

#### 👨‍✈️ Coordinator
An object that bosses around the view controllers.

#### 🏗 Transition Types
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


