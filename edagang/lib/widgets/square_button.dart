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

        Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.0),
          ),
          child: ClipPath(
            clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: Container(
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                  width: lebar,
                  height: tinggi,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
                    child: Image(image: icon.image, ),
                  ),
                  /*child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.circular(8.0),
                    onPressed: () {},
                    color: Colors.transparent,
                    child: Image(image: icon.image, ),
                  ),*/
                )
              )
            )
          )
        ),



        SizedBox(
          height: 8.0,
        ),
        Container(
          height: 20.0,
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.caption.copyWith(color: Colors.black, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
