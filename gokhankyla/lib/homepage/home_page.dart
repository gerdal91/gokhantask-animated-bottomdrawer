import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePageKyla extends StatefulWidget {
  const HomePageKyla({super.key});

  @override
  State<HomePageKyla> createState() => _HomePageKylaState();
}

Offset _offset = Offset(0, 80);

class _HomePageKylaState extends State<HomePageKyla>
    with TickerProviderStateMixin {
  static double _minHeight = 80, _maxHeight = 600;

  bool _isOpen = false;
  Offset? _touchPosition;
  late final AnimationController _animationController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _touchPosition = Offset(0, 0);
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Align(child: _offset.dy > 300 ? SizedBox() : Text("EVENTS")),
            _isOpen
                ? AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return ClipPath(
                        clipper: _CustomClipper(),
                        child: Scaffold(
                          backgroundColor:
                              Colors.blue.withOpacity(convertValue(_offset.dy)),
                          body: _isOpen
                              ? Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: SizedBox()),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              MaterialButton(
                                                child: Text("button 1"),
                                                onPressed: null,
                                              ),
                                              MaterialButton(
                                                child: Text("button 2"),
                                                onPressed: null,
                                              ),
                                              MaterialButton(
                                                child: Text("button 3"),
                                                onPressed: null,
                                              ),
                                              MaterialButton(
                                                child: Text("button 4"),
                                                onPressed: null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ),
                      );
                    },
                  )
                : SizedBox(),
            GestureDetector(
                onPanStart: (details) {
                  _isOpen = true;
                },
                onPanEnd: (details) {
                  if (_offset.dy < 200.0) {
                    _handleClick();
                  }
                  if (_offset.dy > 200.0) {
                    _handleClick();
                  }
                },
                onPanUpdate: (details) {
                  _offset = Offset(0, _offset.dy - details.delta.dy);

                  _touchPosition = details.globalPosition;

                  if (_offset.dy < _HomePageKylaState._minHeight) {
                    _offset = Offset(0, _HomePageKylaState._minHeight);
                    _isOpen = false;
                  } else if (_offset.dy > _HomePageKylaState._maxHeight) {
                    _offset = Offset(0, _HomePageKylaState._maxHeight);
                    _isOpen = true;
                  }
                  setState(() {
                    _offset;
                    _touchPosition;
                    print(_offset.dy);
                  });
                },
                child: AnimatedContainer(
                  duration: Duration.zero,
                  curve: Curves.easeOut,
                  height: _offset.dy * 2,
                  alignment: Alignment.center,
                  child: Positioned(
                    bottom: _offset.dy - 28,
                    child: FloatingActionButton(
                      backgroundColor: _isOpen ? Colors.white : Colors.blue,
                      child: Icon(
                        _isOpen
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: _isOpen ? Colors.blue : Colors.white,
                      ),
                      onPressed: _handleClick,
                    ),
                  ),
                )),
            AnimatedContainer(
                duration: Duration.zero,
                curve: Curves.easeOut,
                height: 160,
                alignment: Alignment.centerRight,
                child: Positioned(
                  bottom: 80 - 28,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      !_isOpen
                          ? IconButton(
                              icon: Icon(Icons.home),
                              onPressed: _handleClick,
                            )
                          : SizedBox(),
                      !_isOpen
                          ? IconButton(
                              icon: Icon(Icons.search),
                              onPressed: _handleClick,
                            )
                          : SizedBox(),
                      SizedBox(
                        width: 28,
                      ),
                      !_isOpen
                          ? IconButton(
                              icon: Icon(Icons.list),
                              onPressed: _handleClick,
                            )
                          : SizedBox(),
                      !_isOpen
                          ? IconButton(
                              icon: Icon(Icons.settings),
                              onPressed: _handleClick,
                            )
                          : SizedBox(),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _handleClick() {
    _isOpen = !_isOpen;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_isOpen) {
        double value = _offset.dy + 10;
        _offset = Offset(0, value);
        if (_offset.dy > _maxHeight) {
          _offset = Offset(0, _maxHeight);
          timer.cancel();
        }
      } else {
        double value = _offset.dy - 10;
        _offset = Offset(0, value);
        if (_offset.dy < _minHeight) {
          _offset = Offset(0, _minHeight);
          timer.cancel();
        }
      }
      setState(() {});
    });
  }
}

class _CustomClipper extends CustomClipper<Path> {
  _CustomClipper();

  @override
  Path getClip(Size size) {
    double factor = (_offset.dy) / 900.0;

    double animationHeight = _offset.dy;
    if (_offset.dy > 300) {
      animationHeight = size.height;
    }

    final path = Path()
      ..moveTo(0, 0) //1.point
      ..lineTo(0, size.height) //second point left bottom
      ..quadraticBezierTo((size.width * 0.5) + (size.width * (0.5 - factor)),
          size.height, size.width * 0.45, animationHeight) //3. point 4 point

      ..quadraticBezierTo(size.width * 0.5, animationHeight + 500,
          size.width * 0.55, animationHeight)
      ..quadraticBezierTo((size.width * 0.5) - (size.width * (0.5 - factor)),
          size.height, size.width, size.height)
      ..lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(_CustomClipper oldClipper) => true;
}

double convertValue(double value) {
  double minValue = 80;
  double maxValue = 600;
  double minTargetValue = 0.0;
  double maxTargetValue = 1.0;

  // Calculate the ratio of the original range
  double ratio = (value - minValue) / (maxValue - minValue);

  // Calculate the corresponding value in the target range
  double targetValue =
      minTargetValue + (maxTargetValue - minTargetValue) * ratio;

  return targetValue;
}
