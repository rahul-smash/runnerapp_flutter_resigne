import 'package:flutter/material.dart';

class StepViewer extends StatelessWidget {
  final double stopsRadius;
  final double pathHeight;
  final double space;
  final Color stopColor;
  final Color pathColor;
  final Color selectedStopColor;
  final Color selectedPathColor;
  final List<String> distanceValues;
  final List<String> stopValues;
  final int current;
  final bool showProgress;

  StepViewer({
    Key key,
    @required this.distanceValues,
    @required this.stopValues,
    this.stopsRadius = 10.0,
    this.pathHeight = 2.0,
    this.space = 2.0,
    this.stopColor = Colors.grey,
    this.pathColor = Colors.grey,
    this.current = 0,
    this.selectedStopColor = Colors.deepPurple,
    this.selectedPathColor = Colors.deepPurple,
    this.showProgress = false,
  })  : assert(distanceValues != null && stopValues != null,
            'distance and stop values can not be null'),
        assert(distanceValues.length < stopValues.length,
            'distance values must be less than stop values'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double distanceWidth = (constraints.maxWidth -
                (stopValues.length * stopsRadius) -
                4 -
                ((stopValues.length * 2) - 2) * space) /
            (stopValues.length - 1);
        return Column(
          children: [
            Stack(
              children: [
                if (showProgress)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(stopValues.length, (index) {
                        return index <= current
                            ? Icon(
                                Icons.check,
                                size: 16.0,
                                color: selectedStopColor,
                              )
                            : SizedBox(
                                width: 16.0,
                              );
                      })),
                Row(
                    children: List.generate(distanceValues.length, (index) {
                  return Expanded(
                      child: Text(
                    distanceValues[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ));
                }))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
              child: Row(
                children: List.generate((stopValues.length * 2) - 1, (index) {
                  if (index % 2 == 0) {
                    return _buildStopView(index);
                  } else {
                    return _buildPathView(distanceWidth, index);
                  }
                }),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(stopValues.length, (index) {
                  return Text(
                    stopValues[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 8.0,
                        fontWeight: FontWeight.w400),
                  );
                })),
          ],
        );
      },
    );
  }

  Widget _buildPathView(double distanceWidth, int index) {
    return Row(
      children: [
        Container(
          height: pathHeight,
          width: distanceWidth,
          color: showProgress
              ? index <= current * 2 + 1
                  ? selectedPathColor
                  : pathColor
              : pathColor,
        ),
        SizedBox(
          width: space,
        )
      ],
    );
  }

  Widget _buildStopView(int index) {
    return Row(
      children: [
        Container(
          width: stopsRadius,
          height: stopsRadius,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: showProgress
                  ? index <= current * 2
                      ? selectedStopColor
                      : stopColor
                  : stopColor),
        ),
        if (index != (stopValues.length * 2) - 2)
          SizedBox(
            width: space,
          )
      ],
    );
  }
}
