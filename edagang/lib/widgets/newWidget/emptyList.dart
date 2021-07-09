import 'package:edagang/main.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/material.dart';
import 'package:edagang/screens/theme/theme.dart';
import 'package:edagang/widgets/newWidget/title_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../customWidgets.dart';

class EmptyList extends StatelessWidget {
  EmptyList(this.title, {this.subTitle});

  final String subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height - 135,
      color: Colors.white,
      child: NotifyText(
        title: title,
        subTitle: subTitle,
      )
    );
  }
}

class NotifyText extends StatelessWidget {
  final String subTitle;
  final String title;
  const NotifyText({Key key, this.subTitle, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleText(title, fontSize: 17, textAlign: TextAlign.center),
        SizedBox(
          height: 20,
        ),
        TitleText(
          subTitle,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColor.darkGrey,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


class EmptyListCartsini extends StatelessWidget {
  EmptyListCartsini(this.title, {this.subTitle});

  final String subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.height - 135,
        color: Colors.white,
        child: NotifyCartsini(
          title: title,
          subTitle: subTitle,
        )
    );
  }
}

class NotifyCartsini extends StatelessWidget {
  final String subTitle;
  final String title;
  const NotifyCartsini({Key key, this.subTitle, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleText(title, fontSize: 17, textAlign: TextAlign.center),
        SizedBox(
          height: 20,
        ),
        TitleText(
          subTitle,
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColor.darkGrey,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width/2,
              child: RaisedButton(
                color: Colors.deepOrange.shade600,
                shape: StadiumBorder(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Continue Shopping",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context, SlideRightRoute(page: NewHomePage(1)));
                },
              ),
            )
        ),
      ],
    );
  }
}