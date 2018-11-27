[![CircleCI](https://circleci.com/gh/RxSwiftCommunity/Action.svg?style=svg)](https://circleci.com/gh/RxSwiftCommunity/Action)

Action
======

This library is used with [RxSwift](https://github.com/ReactiveX/RxSwift) to provide an abstraction on top of observables: actions.

An action is a way to say "hey, later I'll need you to subscribe to this thing." It's actually a lot more involved than that.

Actions accept a `workFactory`: a closure that takes some input and produces an observable. When `execute()` is called, it passes its parameter to this closure and subscribes to the work.

- Can only be executed while "enabled" (`true` if unspecified).
- Only execute one thing at a time.
- Aggregates next/error events across individual executions.

Oh, and it has this really swift thing with `UIButton` that's pretty cool. It'll manage the button's enabled state, make sure the button is disabled while your work is being done, all that stuff 👍

Usage
-----

You have to pass a `workFactory` that takes input and returns an `Observable`. This represents some work that needs to be accomplished. Whenever you call `execute()`, you pass in input that's fed to the work factory. The `Action` will subscribe to the observable and emit the `Next` events on its `elements` property. If the observable errors, the error is sent as a `Next` even on the `errors` property. Neat.

Actions can only execute one thing at a time. If you try to execute an action that's currently executing, you'll get an error. The `executing` property sends `true` and `false` values as `Next` events.

```swift
action: Action<String, Bool> = Action(workFactory: { input in
    return networkLibrary.checkEmailExists(input)
})

...

action.execute("ash@ashfurrow.com")
```

Notice that the first generic parameter is the type of the input, and the second is the type of observable that `workFactory` creates. You can think of it a bit like the action's "output."

You can also specify an `enabledIf` parameter to the `Action` initializer.

```swift
let validEmailAddress = emailTextField.rx.text.map(isValidEmail)

action: Action<String, Bool> = Action(enabledIf: validEmailAddress, workFactory: { input in
    return networkLibrary.checkEmailExists(input)
})
```

Now `execute()` only does the work if the email address is valid. Super cool!

Note that `enabledIf` isn't the same as the `enabled` property. You pass in `enabledIf` and the action uses that, and its current executing state, to determine if it's currently enabled.

What's _really_ cool is the `UIButton` extension. It accepts a `CocoaAction`, which is just `Action<Void, Void>`.

```swift
button.rx.action = action
```

Now when the button is pressed, the action is executed. The button's `enabled` state is bound to the action's `enabled` property. That means you can feed your form-validation logic into the action as a signal, and your button's enabled state is handled for you. Also, the user can't press the button again before the action is done executing, since it only handles one thing at a time. Cool. Check out [this code example of CocoaAction _in_ action](https://github.com/artsy/eidolon/blob/cb31168fa29dcc7815fd4a2e30e7c000bd1820ce/Kiosk/Bid%20Fulfillment/GenericFormValidationViewModel.swift).

If you'd like to use `Action` to do a complex operation such as file download with download progress report (to update progress bar in the UI for example) you'd use `Action<Void, Int>` instead of `CocoaAction`. Out of the box `CocoaAction` can't emit progress values, your own `Action<Void, Int>` will do that. For details refer to [this article](http://www.sm-cloud.com/rxswift-action/).

If your scenario involves many buttons that needs to trigger the same `Action` providing different input, you can use `bindTo` on each `UIButton` with a closure that returns correct input.

```swift
let button1 = UIButton()
let button2 = UIButton()

let action = Action<String, String> { input in
    print(input)
    return .just(input)
}
button1.rx.bindTo(action) { _ in return "Hello"}
button2.rx.bindTo(action) { _ in return "Goodbye"}
```

`button1` and `button2` are sharing the same `Action`, but they are feeding it with different input (`Hello` and `Goodbye` that will be printed for corresponding tap).

A more complex use case can be a single action related to a `UIViewController` that manages your navigation, error handling and loading state. With this approach, you can have as many `UIButton`s (or `UIBarButtonItem`s) as you want and subscribe to `executing`, `errors` and `elements` once and in a single common place.

There's also a really cool extension on `UIAlertAction`, used by [`UIAlertController`](http://ashfurrow.com/blog/uialertviewcontroller-example/). One catch: because of the limitations of that class, you can't instantiate it with the normal initializer. Instead, call this class method:

```swift
let action = UIAlertAction.Action("Hi", style: .default)
```

Installing
----------

### CocoaPods

Just add the line below to your Podfile:

```ruby
pod 'Action'
```

Then run `pod install` and that'll be 👌

### Carthage

Add this to `Cartfile`

```
github "RxSwiftCommunity/Action" ~> 3.6.0
```

If you are using RxSwift 3.2.0 or below, Use Action `~2.2.0` instead!

then run

```
$ carthage update
```

Thanks
------

This library is (pretty obviously) inspired by [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa)'s [`Action` class](https://github.com/ReactiveCocoa/ReactiveCocoa/blob/master/ReactiveCocoa/Swift/Action.swift). Those developers deserve a lot of thanks!

License
-------

MIT obvs.

![Permissive licenses are the only licenses permitted in the Q continuum.](https://38.media.tumblr.com/4ca19ffae09cb09520cbb5611f0a17e9/tumblr_n13vc9nm1Q1svlvsyo6_250.gif)
