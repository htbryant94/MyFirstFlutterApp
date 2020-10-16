import 'dart:ui';

import 'package:fisheri/design_system.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalSlider extends StatefulWidget {
  VerticalSlider({
    this.onChanged
  });

  final ValueChanged<double> onChanged;

  @override
  _VerticalSliderState createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  final double _maxHeight = 260;
  double _yPosition = 100;
  int _sliderValue;
  int _labelOffset = 0;
  bool _indicatorVisible = false;

  @override
  void initState() {
    super.initState();

    _sliderValue = _calculateSliderValue();
    print(_sliderValue);
  }

  int _calculateSliderValue() {
    final positionAsPercentage = ((_maxHeight - _yPosition) / _maxHeight) * 100;
    return positionAsPercentage.round();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108,
      height: 260,
      child: Stack(
        children: [
          GestureDetector(
            onVerticalDragEnd: (dragDetails) {
              setState(() {
                _indicatorVisible = false;
              });
            },
            onTapUp: (_) {
              setState(() {
                _indicatorVisible = false;
              });
            },
            onVerticalDragUpdate: (dragDetails) {
              final currentYPosition = dragDetails.localPosition.dy;
              setState(() {
                if (currentYPosition <= _maxHeight && currentYPosition >= 0) {
                  _yPosition = dragDetails.localPosition.dy;
                } else if (currentYPosition > _maxHeight) {
                  _yPosition = _maxHeight;
                } else if (currentYPosition <= 0) {
                  _yPosition = 0;
                }
                final positionAsPercentage = ((_maxHeight - _yPosition) / _maxHeight) * 100;
                _sliderValue = positionAsPercentage.round();
                widget.onChanged(positionAsPercentage);
                _labelOffset = (_yPosition / 10).round();
//                print("_yPosition: ${_yPosition.round()}");
              });
            },
            onTapDown: (tapDownDetails) {
              final currentYPosition = tapDownDetails.localPosition.dy;
              setState(() {
                _indicatorVisible = true;
                _yPosition = currentYPosition;
                final positionAsPercentage = ((_maxHeight - _yPosition) / _maxHeight) * 100;
                _sliderValue = positionAsPercentage.round();
                widget.onChanged(positionAsPercentage);
                _labelOffset = (_yPosition / 10).round();
              });
            },
            child: Container(
              height: _maxHeight,
              width: 48,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 16,
                      offset: Offset(6,12)
                  )
                ],
              ),
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4)
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: _yPosition),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: _yPosition - _labelOffset,
            left: 50,
            child: AnimatedOpacity(
              opacity: _indicatorVisible ? 1 : 0,
              duration: Duration(milliseconds: 175),
              child: Container(
                width: 50,
                height: 26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 4,
                        offset: Offset(1,2)
                    )
                  ],
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: '${_sliderValue.round()}',
                              style: GoogleFonts.dMSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: DSColors.black
                              ),
                          ),
                          TextSpan(
                            text: 'km',
                            style: GoogleFonts.dMSans(
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                color: DSColors.black
                            ),
                          )
                        ]
                      ),
                    )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}