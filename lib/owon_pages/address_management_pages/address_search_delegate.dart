import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/address_management_pages/address_info_model_entity.dart';
import 'package:owon_pct513/owon_pages/address_management_pages/address_search_list.page.dart';
import 'package:owon_pct513/owon_utils/owon_http.dart';
import 'package:owon_pct513/owon_utils/owon_log.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class SearchBarDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }


  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () => close(context, "点击了返回按钮"),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
//      color: Colors.blue,
      width: double.infinity,
      height: double.infinity,
      child:buildSearchFutureBuilder(query),
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {

    return Container(
//      color: Colors.red,
//      width: double.infinity,
//      height: double.infinity,
//      child: Text("haha",style: TextStyle(
//        color: OwonColor().getCurrent(context, "textColor"),
//      ),),
    );


  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context);
  }



  FutureBuilder<AddressInfoModelEntity> buildSearchFutureBuilder(String key) {
    return new FutureBuilder<AddressInfoModelEntity>(
      builder: (context, AsyncSnapshot<AddressInfoModelEntity> async) {
//        if (async.connectionState == ConnectionState.active ||
//            async.connectionState == ConnectionState.waiting) {
//          return new Center(
//            child: new CircularProgressIndicator(),
//          );
//        }
//
//        if (async.connectionState == ConnectionState.done) {
//          debugPrint('done');
//          if (async.hasError) {
//            return new Center(
//              child: new Text('Error:code '),
//            );
//          } else if (async.hasData) {
//            AddressInfoModelEntity bean = async.data;
//            return AddressSearchListPage();
//          }
//        }


        AddressInfoModelEntity model1 = AddressInfoModelEntity(address: "1 fu jian she xia men shi",description: "si ming qu,ruan jian yuan yi qi B qu",latitude:24.431435605012002,longitude:118.11507750962065  );
        AddressInfoModelEntity model2 = AddressInfoModelEntity(address: "2 fu jian she xia men shi",description: "si ming qu,ruan jian yuan yi qi B qu",latitude:24.4338514,longitude:118.1104348  );
        AddressInfoModelEntity model3 = AddressInfoModelEntity(address: "3 fu jian she xia men shi",description: "si ming qu,ruan jian yuan yi qi B qu",latitude:24.2268488,longitude:118.4947783  );
        AddressInfoModelEntity model4 = AddressInfoModelEntity(address: "4 fu jian she xia men shi",description: "si ming qu,ruan jian yuan yi qi B qu",latitude:24.2368488,longitude:118.6947783  );
        List<AddressInfoModelEntity> tempList = [model1,model2,model3,model4];
        return AddressSearchListPage(tempList);
      },
      future: getSearchData(key),
    );
  }

  Future<AddressInfoModelEntity> getSearchData(String key) async {
    String url = "https://maps.googleapis.com/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA&key=AIzaSyCT52AvaaHzpUTkv7u2yLNDdg7krg0q6wI";
    OwonHttp.getInstance().get(url, (response){
      OwonLog.e("------>${response.toString()}");
      AddressInfoModelEntity bean = AddressInfoModelEntity.fromJson(response.data);
      return bean;
    }, (){});

  }
}

