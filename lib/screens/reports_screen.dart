import 'package:adminpanel/models/user_data.dart';
import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsScreen extends StatefulWidget {
  static const routeName = '/reports';
  ReportsScreen({Key key}) : super(key: key);

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<UserData> delivrys = [];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final adminProvider = Provider.of<AdminFunctioins>(context);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: WebDrawer(
              selectedIndex: 3,
            ),
          ),
          Expanded(
              flex: 5,
              child: FutureBuilder(
                future: adminProvider.getAllDeliveryAccounts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  delivrys = snapshot.data;
                  if (delivrys != null && delivrys.length > 0) {
                    return ListView.builder(
                      itemCount: delivrys.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Text(delivrys[index].name),
                              Text(delivrys[index].number),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("There is no delivery accounts"),
                    );
                  }
                },
              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Container(), /////////// la tzwaed
              );
            },
          );
        },
      ),
    );
  }
}
