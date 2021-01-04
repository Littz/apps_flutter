import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/sign_in.dart';
import 'package:edagang/widgets/page_slide_right.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scoped_model/scoped_model.dart';

class ShopMessagePage extends StatefulWidget {

  @override
  _MessagesState createState() => new _MessagesState();
}

class _MessagesState extends State<ShopMessagePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Widget _showLoginFirst() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            new Image.asset(
              "assets/cartsini_logo.png",
              height: 120.0,
              fit: BoxFit.fitHeight,
            ),
            Container(
              height: 30,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
              child: Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Sign in to view your ",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'Messages',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,),
                            ),
                        ),
                      ],
                    ),
                  )
                //Text("Sign in",style: TextStyle(fontFamily: 'Quicksand',fontSize: 17,color: Colors.grey.shade600,fontWeight: FontWeight.w700))
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 16.0, bottom: 20.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => SignInOrRegister()));
                },
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange.shade500,
                      borderRadius: BorderRadius.circular(25)
                  ),
                  margin: EdgeInsets.fromLTRB(60, 0, 60, 0),
                  child: Center(
                      child: Text('Sign in',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      )
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainScopedModel model){
          return WillPopScope(key: _scaffoldKey, onWillPop: () {
            Navigator.of(context).pushReplacementNamed("/ShopIndex");
            return null;
          },
              child: model.isAuthenticated ? Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomPadding: false,
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.grey.shade100,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  elevation: 0.0,
                  centerTitle: true,
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Text(
                          'Messages ',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xff202020),),
                          ),
                        ),
                        new Text(
                          '('+model.getCartotal().toString()+')',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,),
                          ),
                        ),
                      ]
                  ),
                ),
                body: Center(
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(CupertinoIcons.mail, color: Colors.red.shade500, size: 50,),
                        SizedBox(height: 20,),
                        Text(
                          "You dont't have any new message in the inbox.",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,),
                          ),
                        ),
                        new FlatButton(
                          color: Colors.transparent,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("/ShopIndex");
                          },
                          child: new Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                              child: new Text(
                                "Start shopping",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.deepOrange.shade600),
                                ),
                              )
                          ),
                        )
                      ],
                    )
                ),

              ) : Scaffold(
                key: _scaffoldKey,
                resizeToAvoidBottomPadding: false,
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                body: _showLoginFirst(),
              ));

        });
  }

  _buildCircularProgressIndicator() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
        child: CupertinoActivityIndicator(
          radius: 22,
        ),
      ),
    );
  }

  _emptyContent() {
    return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //SizedBox(height: 80,),
              Icon(CupertinoIcons.mail ,
                color: Colors.red.shade500, size: 50,),
              //Image.asset('images/ic_qrcode3.png', width: 26, height: 26,),
              SizedBox(height: 20,),
              Text(
                'Empty Message.',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,),
                ),
              ),
              new FlatButton(
                color: Colors.transparent,
                onPressed: () {
                  //Navigator.push(context,MaterialPageRoute(builder: (context){return IndexApp();}));
                },
                child: new Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: new Text(
                      "START SHOPPING",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.deepOrange.shade600),
                      ),
                    )
                ),
              )
            ],
          ),
        )
    );
  }

}
