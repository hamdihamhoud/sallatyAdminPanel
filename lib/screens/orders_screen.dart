import 'package:adminpanel/models/user_data.dart';
import 'package:adminpanel/providers/orders.dart';
import 'package:adminpanel/widgets/order_item.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  OrdersScreen({Key key}) : super(key: key);

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order> orders = [];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final ordersProvider = Provider.of<Orders>(context);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: WebDrawer(
              selectedIndex: 0,
            ),
          ),
          Expanded(
              flex: 5,
              child: FutureBuilder(
                future: ordersProvider.getOrdersNotConfirmed(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  orders = snapshot.data;
                  if (orders != null && orders.length > 0) {
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, i) {
                        int products = orders[i].products.length;
                        UserData userData;
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.primaryColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            width: double.infinity,
                            child: Column(
                              children: [
                                FutureBuilder(
                                    future: ordersProvider
                                        .getUserData(orders[i].buyerId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting)
                                        return Center(child: Container());
                                      userData = snapshot.data;
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 15,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "Name: ",
                                                    style: TextStyle(
                                                      color: theme.primaryColor,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                Container(
                                                  width: size.width * 0.2,
                                                  child: Text(
                                                    "${userData.name}",
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "Number :",
                                                    style: TextStyle(
                                                      color: theme.primaryColor,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                Container(
                                                  width: size.width * 0.2,
                                                  child: Text(
                                                    "${userData.number}",
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    'Address: ',
                                                    style: TextStyle(
                                                      color: theme.primaryColor,
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    overflow: TextOverflow.fade,
                                                  ),
                                                ),
                                                Container(
                                                  width: size.width * 0.2,
                                                  child: Text(
                                                    '${orders[i].address}',
                                                    style: TextStyle(
                                                      color: Color(0xFF333333),
                                                      fontSize: 19,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                for (int j = 0; j < products; j++)
                                  OrderItem(
                                    theme: theme,
                                    orders: orders,
                                    i: i,
                                    index: j,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                    bottom: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: size.width * 0.3,
                                        height: 35,
                                        child: TextButton(
                                          onPressed: () async {
                                            await ordersProvider
                                                .checkAsConfirmed(orders[i].id);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    OrdersScreen.routeName);
                                          },
                                          child: Text(
                                            "Confirm Order",
                                            style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 21,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: theme.accentColor,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: size.width * 0.3,
                                        height: 35,
                                        child: TextButton(
                                          onPressed: () async {
                                            await ordersProvider
                                                .deleteOrder(orders[i].id);
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    OrdersScreen.routeName);
                                          },
                                          child: Text(
                                            "Delete Order",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 21,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                        child: Text('There is no not confirmed orders'));
                  }
                },
              )),
        ],
      ),
    );
  }
}
