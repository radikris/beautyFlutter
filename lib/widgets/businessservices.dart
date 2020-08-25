import 'package:flutter/material.dart';
import '../utilities/constans.dart';
import '../widgets/onlyservice/servicetile.dart';

class BusinessService extends StatelessWidget {
  List<dynamic> serviceList;
  Function deleteService;
  String businessid;
  BusinessService(this.serviceList, this.deleteService, this.businessid);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'Services',
            style: kTitleStyle,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          //height: 500,
          child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).primaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(4.0)),
            child: (serviceList != null && serviceList.length > 0)
                ? ListView.builder(
                  primary: false,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    itemCount: serviceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ServiceTile(this.businessid, serviceList[index],
                          index, deleteService);
                    })
                : Center(
                    child: Text('No services yet...', style: kSubtitleStyle)),
          ),
        ),
      ],
    );
  }
}
