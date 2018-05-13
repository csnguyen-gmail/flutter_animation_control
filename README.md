# Flutter: Experiment to trigger animation from parent widget

Have you ever tried to control animation of child widget from parent widget? Sound like easy, isn't it! 

But believe or not, as newbie in Reactive programming style like me, it took me full day long to pass by.

So I want to share my problems and solutions when I try to control animation of child widget from parent widget. Ok let's see the requirement.

### Application Requirement

The screen have 2 main widgets, the parent who own that app state, and the child reflect the app state through their UI. Every times parent widget change value and setState, child widget will get the newest state from parent to update UI and **trigger animation** to high light the change.

Something like below:

<p align="center">
  <img src="/blob/flutter_animation_control.gif">
</p>

### Approach1: animation is triggered in InitState of child State.

Parent widget store app state, update state with setState call when tap to action button

Child widget is StatefulWidget, AnimationController is store in child State:

**Parent widget**

```dart
class _MainWidgetState extends State<MainWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: AnimatedText(text: "Number $counter")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            ++counter;
          });
        },
      ),
    );
  }
}
```

**Child widget**
```dart
class AnimatedText extends StatefulWidget {
  AnimatedText({this.text});
  final String text;
  @override
  _AnimatedTextState createState() => new _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Color> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = new ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller)..addListener((){
      setState(() {});
    });
    _controller.forward();

    super.initState();
  }

  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text, style: TextStyle(
        fontSize: 40.0,
        fontWeight: FontWeight.bold,
        color: _animation.value
    ),);
  }
}
```

Some boiler plate code about AnimationController which I don't intend to explain, hope you guys familiar with it.

**Result**

I though above code will run correctly, every times setState function is called at parent widget, new State instance of child is recreated then initState function is called and animation is triggered.

But the fact that, animation is only trigger when application run, no animation when tap to action button. The reason is when parent rebuilds, the parent will create a new instance of child widget, but the framework will reuse the child state  instance that is already in the tree rather than calling createState again.

At that moment, I think I could understand what Flutter said in their [official page](https://flutter.io/widgets-intro/) 😅

Ok, let's fix it with my second approach.

### Approach2: try to get InitState is called with UniqueKey

I come to second approach with a silly idea that how to trigger InitState every times parent widget is built. To do that I need to tell the framework recreate child state every times create new instance of child widget by assigning a UniqueKey to child widget.

**Parent**:

```dart
  Widget build(BuildContext context) {
//... 
            child: AnimatedText(
                key: UniqueKey(),
                text: "Number $counter",
            )
//...
```

 Assign unique key every time create child widget.

**Child**
```dart
class AnimatedText extends StatefulWidget {
  AnimatedText({
    Key key, 
    this.text
  }):super(key:key);
//...  
```

Assign received key from parent to widget through `super(key:key)`function.

**Result**

It's work, animation is triggered every times I tapped to action button. But some problems

* It feel not right when we break the way framework manage the state just for an irrelative demand.
* Animation is trigger even setState is not called by our self, it's trigger when build function of parent is called which is able happen when we resume application or another reason.

This approach is not good, and I move to the third.

### Approach3: trigger Animation explicit from parent with GlobalKey

How's about forget reactive style and back to imperative style? (I recommend you read this post for more information about reactive & imperative style from this [post](https://hackernoon.com/why-native-app-developers-should-take-a-serious-look-at-flutter-e97361a1c073?token=QskrKFQ_6idgbnJ7))

Parent will keep instance of child state and trigger animation every times need, to do that we use GlobalKey to create key for child widget and keep reference to child state.

**Parent**:

```dart
class _MainWidgetState extends State<MainWidget> {
  int counter = 0;
  final GlobalKey<AnimatedTextState> animatedStateKey = GlobalKey<AnimatedTextState>();
//...
```
```dart
  Widget build(BuildContext context) {
//...      
            child: AnimatedText(
              key: animatedStateKey,
              text: "Number $counter ",
            )
//...
```
```dart
//...
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            ++counter;
            animatedStateKey.currentState.updateTextWithAnimation("Number $counter");
          });
        },
      ),
//...
```
We can het child state from GlobalKey

**Child**
```dart
//...
  void updateTextWithAnimation(String text) {
    setState(() {
      this.text = text;
    });
    _controller.reset();
    _controller.forward();
  }
//...
```

Public new function to trigger animation.

**Result**

It's also work. At glance it look good due familiar coding with native mobile developer like me, but is it really good?

* Why we approach Imperative style while Flutter framework is about Reactive style
* Seriously use GlobalKey just for temporary, local case

I also have another approach by moving AnimationController from child widget to parent widget, and then parent will trigger animation instead of child. 

Again this way is also look like Imperative style, and parent have to content a lot of boiler plate code to create AnimationController. This approach is the best so far and also written as sample from [Flutter home page](https://github.com/flutter/website/tree/master/_includes/code/animation/basic_staggered_animation), but I'm still not be convinced with the way by letting parent take a part of child duty by manage AnimationController.

I did research the library and final find the way to trigger animation when parent setState, let's move to Final approach

### Final approach: didUpdateWidget function for the rescue

It turn out, there is a function is triggered from child state every time its new widget instance is created `didUpdateWidget`. Now all you need is back to Approach1 and implement didUpdateWidget to trigger animation. 🤪

**Child**

```dart
//...
  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
  }
//...
```

Ok, I know it look like my head have problem when moving in a big circle and final landing at the beginning with the solution right in front of eye. 

But it's my truly journey, I think it's because I still don't know the framework clearly and still stick with Imperative style since I'm from native developer. Through these mistake I understand more about the framework and little by little make friend with Imperative style. I hope this post also help you somehow. Happy coding!

Note: you can refer the source code from [here](https://github.com/csnguyen-gmail/flutter_animation_control).
