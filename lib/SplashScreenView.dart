library splash_screen_view;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/ColorizeAnimatedText.dart';
import 'package:splash_screen_view/ScaleAnimatedText.dart';
import 'package:splash_screen_view/TyperAnimatedText.dart';

enum TextType {
  ColorizeAnimationText,
  TyperAnimatedText,
  ScaleAnimatedText,
  NormalText,
}

// ignore: must_be_immutable
class SplashScreenView extends StatefulWidget {
  /// The [Widget] Name of target screen which you want to display after completion of splash screen milliseconds.
  late Widget _home;

  ///  [String] Asset path of your logo image.
  late String _imageSrc = "";

  ///  [String] that would be displayed on below logo.
  late String _text;

  /// Select [TextType] of your text.
  ///
  /// By default it is NormalText.
  late TextType _textType;

  /// Gives [TextStyle] to the text strings.
  late TextStyle _textStyle;

  /// The [Duration] of the delay between the apparition of each characters
  ///
  /// By default it is set to 3000 milliseconds.
  late int _duration = 3000;

  ///  [int] Size of your image logo.
  ///
  /// By default it is set to 150.
  late int _logoSize = 150;

  ///  [Color] Background Color of your splash screen.
  /// By default it is set to white.
  Color _backgroundColor = Colors.white;

  /// Set the colors for the gradient animation of the text.
  ///
  /// The [List] should contain at least two values of [Color] in it.
  /// By default it is set to red and black.
  late List<Color> _colors;

  Future<dynamic>? _future;

  late bool _waitUntilPop;

  late bool _redirectUponPop;

  String? _loadingText;

  String? _errorText;

  String? _successText;

  Widget? _homeOnError;

  double _defaultTextFontSize = 20;

  SplashScreenView(
      {required String imageSrc,
      required Widget home,
      required int duration,
      int? imageSize,
      textStyle,
      colors,
      textType,
      backgroundColor,
      text,
      Future<dynamic>? future,
      bool waitUntilPop = false,
      bool redirectUponPop = true,
      String? successText,
      String? loadingText,
      String? errorText,
      Widget? homeOnError}) {
    assert(duration != null);
    assert(home != null);
    assert(imageSrc != null);

    _imageSrc = imageSrc;
    _home = home;
    _duration = duration;
    _colors = colors;
    _text = text;
    _textStyle = textStyle;
    _logoSize = imageSize ?? 10;
    _backgroundColor = backgroundColor;
    _textType = textType;

    _future = future;
    _waitUntilPop = waitUntilPop;
    _redirectUponPop = redirectUponPop;
    _loadingText = loadingText ?? "Loading...";
    _errorText = errorText ?? "Error!";
    _homeOnError = homeOnError ?? Container(child: Text("HOME ERROR"));
    _successText = successText ?? "SUCCESS";
  }

  @override
  _SplashScreenViewState createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget._duration < 1000) widget._duration = 3000;

    if (widget._textType == TextType.TyperAnimatedText) {
      _animationController = new AnimationController(
          vsync: this, duration: Duration(milliseconds: 100));
      _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInCirc));
      _animationController.forward();
    } else {
      _animationController = new AnimationController(
          vsync: this, duration: Duration(milliseconds: 1000));
      _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController, curve: Curves.easeInCirc));
      _animationController.forward();
    }

    if(widget._future == null){
      Future.delayed(Duration(milliseconds: widget._duration)).then((value) => 
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (BuildContext context) => widget._home))
      );
    }

  }

  @override
  void dispose() {
    super.dispose();
    _animationController.reset();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if(widget._waitUntilPop){
          if(widget._redirectUponPop){
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(builder: (BuildContext context) => widget._home));
          }
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: widget._backgroundColor,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                (widget._imageSrc != null)
                    ? Image.asset(
                        widget._imageSrc,
                        height: (widget._logoSize != null)
                            ? widget._logoSize.toDouble()
                            : 150,
                      )
                    : SizedBox(
                        height: 1,
                      ),
                (widget._future != null)
                ?
                FutureBuilder(
                  future: widget._future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {

                    String text;

                    if(snapshot.hasData){
                      text = widget._text + "\n\n" + widget._successText!;
                      Future.delayed(Duration(milliseconds: 3000)).then((value) => 
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(builder: (BuildContext context) => widget._home))
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                        child: getTextWidget(text),
                      );
                      // Future.delayed(Duration(milliseconds: widget._duration)).then((value) {
                      //   Navigator.of(context).pushReplacement(
                      //       CupertinoPageRoute(builder: (BuildContext context) => widget._home));
                      // });
                    } else if(snapshot.hasError){
                      text = widget._text + "\n\n" + widget._errorText!;
                      Future.delayed(Duration(milliseconds: 3000)).then((value) => 
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(builder: (BuildContext context) => widget._homeOnError!))
                      );
                      return Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                        child: getTextWidget(text),
                      );
                    } else {
                      text = widget._text + "\n\n" + widget._loadingText!;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                        child: getTextWidget(text),
                      );
                    }

                  },
                )
                :
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                  child: getTextWidget(widget._text),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTextWidget(String text) {
    if (widget._text != null) {
      print("Not Blank");
      switch (widget._textType) {
        case TextType.ColorizeAnimationText:
          return ColorizeAnimatedText(
            text: text,
            speed: Duration(milliseconds: 1000),
            textStyle: (widget._textStyle != null)
                ? widget._textStyle
                : TextStyle(fontSize: widget._defaultTextFontSize),
            colors: (widget._colors != null)
                ? widget._colors
                : [
                    Colors.red,
                    Colors.black,
                    Colors.red,
                    Colors.black,
                  ],
          );
        case TextType.NormalText:
          return Text(
            text,
            style: (widget._textStyle != null)
                ? widget._textStyle
                : TextStyle(fontSize: widget._defaultTextFontSize),
          );
        case TextType.TyperAnimatedText:
          return TyperAnimatedText(
            text: text,
            speed: Duration(milliseconds: 100),
            textStyle: (widget._textStyle != null)
                ? widget._textStyle
                : TextStyle(fontSize: widget._defaultTextFontSize),
          );
        case TextType.ScaleAnimatedText:
          return ScaleAnimatedText(
            text: text,
            textStyle: (widget._textStyle != null)
                ? widget._textStyle
                : TextStyle(fontSize: widget._defaultTextFontSize),
          );
        default:
          return Text(
            text,
            style: (widget._textStyle != null)
                ? widget._textStyle
                : TextStyle(fontSize: widget._defaultTextFontSize),
          );
      }
    } else {
      print("Blank");
      return SizedBox(
        width: 1,
      );
    }
  }
}
