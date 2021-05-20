import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/utils/constant.dart';
import 'package:edagang/widgets/html2text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions, text, file_img;
  final Image img;

  const CustomDialogBox({Key key, this.title, this.descriptions, this.text, this.file_img, this.img}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context){
    return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius + Constants.padding, right: Constants.padding,bottom: Constants.padding),
            margin: EdgeInsets.only(top: Constants.padding),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(Constants.padding),
                boxShadow: [
                  BoxShadow(color: Colors.black,offset: Offset(0,10),
                      blurRadius: 10
                  ),
                ]
            ),
            child: widget.text.toLowerCase() == 'noorlida abd kadir' ? new SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    htmlText(widget.descriptions),
                    SizedBox(height: 22,),
                  ],
                )
              ) : new SingleChildScrollView(
                child: widget.file_img == 'null' ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600, color: Color(0xff2877EA)),),
                    SizedBox(height: 15,),
                    htmlText(widget.descriptions),
                    SizedBox(height: 22,),
                  ],
                ) : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 15,),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.transparent,
                              child: CupertinoActivityIndicator(
                                radius: 17,
                              ),
                            ),
                            imageUrl: widget.file_img,
                            fit: BoxFit.cover,
                          ),
                        )
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600, color: Color(0xff2877EA)),),
                    SizedBox(height: 15,),
                    htmlText(widget.descriptions),
                    SizedBox(height: 22,),
                  ],
                )
              ),
          ),
          Positioned(
            top: 5,
            left: 0,
            child: CloseButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
              color: Colors.red.shade600,
              //child: Text(widget.text,style: TextStyle(fontSize: 18),)
            )
          ),
        ],

    );
  }


}