import 'package:cached_network_image/cached_network_image.dart';
import 'package:edagang/scoped/main_scoped.dart';
import 'package:edagang/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<IconData> _icons = [
    Icons.offline_bolt,
    Icons.ac_unit,
    Icons.dashboard,
    Icons.backspace,
    Icons.cached,
    Icons.edit,
    Icons.face,
  ];

  List<IconData> _selectedIcons = [];

  @override
  Widget build(BuildContext context) {
    Widget gridViewSelection = GridView.count(
      childAspectRatio: 2.0,
      crossAxisCount: 3,
      mainAxisSpacing: 20.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      children: _icons.map((iconData) {
        return GestureDetector(
          onTap: () {
            _selectedIcons.clear();

            setState(() {
              _selectedIcons.add(iconData);
            });
          },
          child: GridViewItem(iconData, _selectedIcons.contains(iconData)),
        );
      }).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Selectable GridView'),
      ),
      body: _fetchFpxBanks(), //gridViewSelection,
    );
  }

  Widget _fetchFpxBanks() {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (context, child, model){
          return Container(
            margin: EdgeInsets.only(left: 10, right: 10,),
            color: Colors.transparent,
            //height: 130,
            alignment: Alignment.centerLeft,
            child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: model.bankList.length,
              itemBuilder: (context, index) {
                var data = model.bankList[index];
                return Container(
                  padding: EdgeInsets.only(right: 9),
                  alignment: Alignment.center,
                  child: InkWell(
                      onTap: () {
                        model.bankList.clear();
                        setState(() {
                          model.bankList.add(data);
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(color: Color(0xffF45432), width: 1.0,),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: 70.0,
                                width: 70.0,
                                imageUrl: Constants.urlImage + data.bank_logo ?? '',
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: 30,
                                  height: 30,
                                  color: Colors.transparent,
                                  child: CupertinoActivityIndicator(radius: 15,),
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                          ),
                          Container(
                            width: 70.0,
                            padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(
                                    data.bank_display_name,
                                    style: new TextStyle(fontSize: 11.0,fontFamily: "Quicksand", color: Colors.black),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                );
              },
            ),
          );
        }
    );
  }


}

class GridViewItem extends StatelessWidget {
  final IconData _iconData;
  final bool _isSelected;

  GridViewItem(this._iconData, this._isSelected);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        _iconData,
        color: Colors.white,
      ),
      shape: CircleBorder(),
      fillColor: _isSelected ? Colors.blue : Colors.black,
      onPressed: null,
    );
  }
}