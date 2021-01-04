import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final String label;
  final Image icon;
  final double lebar;
  final double tinggi;

  SquareButton({
    @required this.label,
    @required this.icon,
    @required this.lebar,
    @required this.tinggi,
  })  : assert(label != null),
        assert(icon != null),
        assert(lebar != null),
        assert(tinggi != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: lebar,
          height: tinggi,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(8.0),
            onPressed: () {},
            color: Colors.white,
            child: Image(image: icon.image,),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: lebar,
          height: 20.0,
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}
