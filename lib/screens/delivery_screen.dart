import 'package:adminpanel/models/user_data.dart';
import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/widgets/signup_delivery_form.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class DeliveryScreen extends StatefulWidget {
  static const routeName = '/delivery';
  DeliveryScreen({Key key}) : super(key: key);

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
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
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.05,
                          secondaryActions: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 5,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: IconSlideAction(
                                  caption: 'Delete',
                                  color: Colors.red,
                                  icon: Icons.delete,
                                  onTap: () => {
                                    adminProvider
                                        .deleteDelivery(delivrys[index].id),
                                    Navigator.pushReplacementNamed(
                                        context, DeliveryScreen.routeName),
                                  },
                                ),
                              ),
                            ),
                          ],
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
                                      delivrys[index].name,
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
                                      delivrys[index].number,
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
        tooltip: 'Add New Delivery Account',
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: SignupDeliveryForm(),
            ),
          );
        },
      ),
    );
  }
}
