import 'package:flutter/material.dart';

class THeader extends StatelessWidget {
  ///Builds elements for the table headers
  const THeader(
      {Key key,
      @required this.thPaddingLeft,
      @required this.thPaddingTop,
      @required this.thPaddingBottom,
      @required this.thPaddingRight,
      @required List headers,
      @required this.thAlignment,
      @required this.thStyle,
      @required FontWeight thWeight,
      @required double thSize,
      @required double widthRatio,
      @required int index})
      : _headers = headers,
        _thWeight = thWeight,
        _thSize = thSize,
        _index = index,
        _widthRatio = widthRatio,
        super(key: key);

  final double thPaddingLeft;
  final double thPaddingTop;
  final double thPaddingBottom;
  final double thPaddingRight;
  final List _headers;
  final TextAlign thAlignment;
  final TextStyle thStyle;
  final FontWeight _thWeight;
  final double _thSize;
  final int _index;
  final double _widthRatio;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            color: Theme.of(context).backgroundColor,
            width: width * _widthRatio,
            height: 50,
            child: Padding(
              padding: EdgeInsets.only(
                  left: thPaddingLeft,
                  top: 10,
                  bottom: thPaddingBottom,
                  right: thPaddingRight),
              child: Text(
                _headers != null || _headers.isNotEmpty
                    ? _headers[_index]['title']
                    : '',
                style: thStyle ??
                    TextStyle(fontWeight: _thWeight, fontSize: _thSize),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: VerticalDivider(
            color: Colors.grey[500],
            width: 0,
          ),
        ),
      ],
    );
  }
}
