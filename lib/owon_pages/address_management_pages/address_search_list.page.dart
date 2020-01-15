import 'package:flutter/material.dart';
import 'package:owon_pct513/owon_pages/address_management_pages/address_envebus.dart';
import 'package:owon_pct513/owon_pages/address_management_pages/address_info_model_entity.dart';
import 'package:owon_pct513/owon_providers/owon_evenBus/list_evenbus.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class AddressSearchListPage extends StatefulWidget {
  List<AddressInfoModelEntity> addressList;
  AddressSearchListPage(this.addressList);
  @override
  _AddressSearchListPageState createState() => _AddressSearchListPageState();
}

class _AddressSearchListPageState extends State<AddressSearchListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child:
        Container(
          child: ListView.builder(
              itemBuilder: (context,index){
            return ListTile(
              title: Text("${widget.addressList[index].address}",style: TextStyle(color: OwonColor().getCurrent(context, "textColor")),),
              subtitle: Text("${widget.addressList[index].description}",style: TextStyle(color: OwonColor().getCurrent(context, "textColor")),),
              onTap: (){
                AddressEventBus.getDefault().post(widget.addressList[index]);

                Navigator.of(context).pop("点击了第$index行");
              },
            );
          },
            itemCount: widget.addressList.length,
          ),
        )
    );
  }
}
