import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:owon_pct513/owon_api/model/address_model_entity.dart';
import 'package:owon_pct513/owon_pages/address_management_pages/address_devices_page.dart';
import 'package:owon_pct513/res/owon_constant.dart';
import 'package:owon_pct513/res/owon_picture.dart';
import 'package:owon_pct513/res/owon_themeColor.dart';

class AddressListPage extends StatefulWidget {
  AddressModelEntity addrModels;
  AddressListPage(this.addrModels);
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("地址列表"),
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.add,
                  color: OwonColor().getCurrent(context, "textColor"),
                  size: 30,
                ))
          ],
        ),
        body: ListView.builder(
            itemCount: widget.addrModels.addrs.length,
            itemBuilder: (context, index) {
              return Container(
                  height: OwonConstant.listHeight,
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  child: InkWell(
                    onTap: () {
                      AddressModelAddr addrModel = widget.addrModels.addrs[index];
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return AddressDevicesPage(addrModel);
                      }));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color:
                                OwonColor().getCurrent(context, "borderNormal"),
                            width: 1.0,
                          ),
                          borderRadius:
                              BorderRadius.all(Radius.circular(16.0))),
                      child: Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                              child: SvgPicture.asset(
                                OwonPic.addressHome,
                                color: OwonColor().getCurrent(context, "textColor"),
                                width: 20,
                              )),
                          Container(
                            width: 250,
                            margin: EdgeInsets.only(top: 15.0),
//                  color: Colors.purple,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.addrModels.addrs[index].addrname,
                                  style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "textColor"),
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                 widget.addrModels.addrs[index].addrname,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: OwonColor()
                                        .getCurrent(context, "textColor"),
                                    fontSize: 15.0,
                                  ),
                                ),
                                Text(
                                  "${widget.addrModels.addrs[index].devlist.length} devices",
                                  style: TextStyle(
                                      color: OwonColor()
                                          .getCurrent(context, "textColor"),
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_right,
                            color: OwonColor().getCurrent(context, "textColor"),
                          )
                        ],
                      )),
                    ),
                  ));
            }));
  }
}
