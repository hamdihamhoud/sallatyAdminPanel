import 'package:adminpanel/models/user_data.dart';
import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/widgets/create_premium.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class VendorsScreen extends StatefulWidget {
  static const routeName = '/vendors';
  VendorsScreen({Key key}) : super(key: key);

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  List<UserData> vendors = [];
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminFunctioins>(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: WebDrawer(
              selectedIndex: 1,
            ),
          ),
          Expanded(
            flex: 5,
            child: FutureBuilder(
              future: adminProvider.getAllPremiumAccounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                vendors = snapshot.data;
                if (vendors != null && vendors.length > 0) {
                  return ListView.builder(
                    itemCount: vendors.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                              border: Border.all(
                                width: 2,
                                color: theme.accentColor,
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name: ",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    vendors[index].name,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Number: ",
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    vendors[index].number,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text("There is no vendors accounts"),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(
            Icons.add,
            color: Color(0xFF333333),
          ),
        ),
        backgroundColor: theme.primaryColor,
        tooltip: 'Add New premium Account',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: CreatePremium(),
            ),
          );
        },
      ),
    );
  }
}
