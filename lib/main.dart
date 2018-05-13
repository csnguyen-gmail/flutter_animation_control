import 'package:flutter/material.dart';
//// Approach1: animation is triggered in InitState of child State.
//class AnimatedText extends StatefulWidget {
//  AnimatedText({this.text});
//  final String text;
//  @override
//  _AnimatedTextState createState() => new _AnimatedTextState();
//}
//
//class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//  Animation<Color> _animation;
//
//  @override
//  void initState() {
//    _controller = AnimationController(
//      duration: const Duration(milliseconds: 1000),
//      vsync: this,
//    );
//
//    _animation = new ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller)..addListener((){
//      setState(() {});
//    });
//    _controller.forward();
//
//    super.initState();
//  }
//
//  dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Text(widget.text, style: TextStyle(
//        fontSize: 40.0,
//        fontWeight: FontWeight.bold,
//        color: _animation.value
//    ),);
//  }
//}
//
//class MainWidget extends StatefulWidget {
//  @override
//  _MainWidgetState createState() => new _MainWidgetState();
//}
//
//class _MainWidgetState extends State<MainWidget> {
//  int counter = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        child: Center(child: AnimatedText(text: "Number $counter")),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          setState(() {
//            ++counter;
//          });
//        },
//      ),
//    );
//  }
//}

//// Approach2: try to get InitState is called with UniqueKey
//class AnimatedText extends StatefulWidget {
//  AnimatedText({
//    Key key,
//    this.text
//  }):super(key:key);
//
//  final String text;
//  @override
//  _AnimatedTextState createState() => new _AnimatedTextState();
//}
//
//class _AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//  Animation<Color> _animation;
//
//  @override
//  void initState() {
//    _controller = AnimationController(
//      duration: const Duration(milliseconds: 1000),
//      vsync: this,
//    );
//
//    _animation = new ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller)..addListener((){
//      setState(() {});
//    });
//    _controller.forward();
//
//    super.initState();
//  }
//
//  dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Text(widget.text, style: TextStyle(
//        fontSize: 40.0,
//        fontWeight: FontWeight.bold,
//        color: _animation.value
//    ),);
//  }
//}
//
//class MainWidget extends StatefulWidget {
//  @override
//  _MainWidgetState createState() => new _MainWidgetState();
//}
//
//class _MainWidgetState extends State<MainWidget> {
//  int counter = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        child: Center(
//            child: AnimatedText(
//                key: UniqueKey(),
//                text: "Number $counter",
//            )
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          setState(() {
//            ++counter;
//          });
//        },
//      ),
//    );
//  }
//}

//// Approach4: move AnimationController to parent
//class AnimatedText extends StatefulWidget {
//  AnimatedText({Key key, this.text}):super(key:key);
//  final String text;
//  @override
//  AnimatedTextState createState() => new AnimatedTextState();
//}
//
//class AnimatedTextState extends State<AnimatedText> with SingleTickerProviderStateMixin {
//  AnimationController _controller;
//  Animation<Color> _animation;
//  String text;
//
//  @override
//  void initState() {
//    text = widget.text;
//    _controller = AnimationController(
//      duration: const Duration(milliseconds: 1000),
//      vsync: this,
//    );
//
//    _animation = new ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller)..addListener((){
//      setState(() {});
//    });
//    _controller.forward();
//
//    super.initState();
//  }
//
//  dispose() {
//    _controller.dispose();
//    super.dispose();
//  }
//
//  void updateTextWithAnimation(String text) {
//    setState(() {
//      this.text = text;
//    });
//    _controller.reset();
//    _controller.forward();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Text(text, style: TextStyle(
//        fontSize: 40.0,
//        fontWeight: FontWeight.bold,
//        color: _animation.value
//    ),);
//  }
//}
//
//class MainWidget extends StatefulWidget {
//  @override
//  _MainWidgetState createState() => new _MainWidgetState();
//}
//
//class _MainWidgetState extends State<MainWidget> {
//  int counter = 0;
//  final GlobalKey<AnimatedTextState> animatedStateKey = GlobalKey<AnimatedTextState>();
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        child: Center(
//            child: AnimatedText(
//              key: animatedStateKey,
//              text: "Number $counter ",
//            )
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          setState(() {
//            ++counter;
//            animatedStateKey.currentState.updateTextWithAnimation("Number $counter");
//          });
//        },
//      ),
//    );
//  }
//}

//// APPROACH NG - move AnimationXController to parent
//class AnimatedText extends StatelessWidget {
//  AnimatedText({
//    this.text,
//    this.controller,
//  }):_animation = new ColorTween(begin: Colors.red, end: Colors.blue).animate(controller);
//
//  final String text;
//  final AnimationController controller;
//  final Animation<Color> _animation;
//
//  @override
//  Widget build(BuildContext context) {
//    return new AnimatedBuilder(
//      animation: controller,
//      builder: (BuildContext context, Widget child) {
//        return Text(text, style: TextStyle(
//            fontSize: 40.0,
//            fontWeight: FontWeight.bold,
//            color: _animation.value,
//        ));
//      },
//    );
//  }
//}
//
//class MainWidget extends StatefulWidget {
//  @override
//  _MainWidgetState createState() => new _MainWidgetState();
//}
//
//class _MainWidgetState extends State<MainWidget> with SingleTickerProviderStateMixin{
//  int counter = 0;
//  AnimationController controller;
//
//  @override
//  void initState() {
//    controller = AnimationController(
//      duration: const Duration(milliseconds: 1000),
//      vsync: this,
//    );
//    controller.forward();
//
//    super.initState();
//  }
//
//  dispose() {
//    controller.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        child: Center(
//            child: AnimatedText(
//              controller: controller,
//              text: "Number $counter ",
//            )
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          setState(() {
//            ++counter;
//          });
//          controller.reset();
//          controller.forward();
//        },
//      ),
//    );
//  }
//}

// Final: didUpdateWidget function for the rescue
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

  @override
  void didUpdateWidget(AnimatedText oldWidget) {
    _controller.reset();
    _controller.forward();
    super.didUpdateWidget(oldWidget);
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

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => new _MainWidgetState();
}

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


void main() {
  runApp(new MaterialApp(home: new MainWidget()));
}