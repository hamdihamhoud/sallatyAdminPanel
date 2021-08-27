import 'package:adminpanel/models/user_data.dart';
import 'package:adminpanel/providers/orders.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
                        UserData userData;
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.primaryColor,
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
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Name: ${userData.name}"),
                                          Text("Number: ${userData.number}"),
                                          Text('Address: ${orders[i].address}')
                                        ],
                                      );
                                    }),
                                OrderItem(
                                  theme: theme,
                                  orders: orders,
                                  i: 0,
                                  index: 0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: size.width * 0.1,
                                      child: TextButton(
                                        onPressed: () {
                                          ordersProvider
                                              .checkAsConfirmed(orders[i].id);
                                        },
                                        child: Text("Confirm"),
                                        style: TextButton.styleFrom(
                                          backgroundColor: theme.accentColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.1,
                                      child: TextButton(
                                        onPressed: () {
                                          ordersProvider
                                              .deleteOrder(orders[i].id);
                                        },
                                        child: Text("Delete"),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
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
                        child: Text('There is no not confirmed orders'));
                  }
                },
              )),
        ],
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key key,
    @required this.theme,
    @required this.orders,
    @required this.index,
    @required this.i,
  }) : super(key: key);
  final int index, i;
  final ThemeData theme;
  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ordersProvider = Provider.of<Orders>(context);
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.accentColor,
          ),
        ),
        width: double.infinity,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.15,
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
                    ordersProvider
                        .deleteOrderItemFromOrder(orders[i].products[index].id),
                  },
                ),
              ),
            ),
          ],
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.all(
                color: Theme.of(context).accentColor,
                width: 2,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: CachedNetworkImage(
                              width:
                                  MediaQuery.of(context).size.width / 4 * 0.8,
                              height: 90,
                              imageUrl: orders[index].products[index].imageUrl,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (ctx, str, downloadProgress) => Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(child: const Icon(Icons.error)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              top: 2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orders[i].products[index].title,
                                  style: TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Text(
                                    "${orders[i].products[index].price.toStringAsFixed(0)} S.P",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            orders[i]
                                .products[index]
                                .quantity
                                .toStringAsFixed(0),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF3333333),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: orders[i].products[index].size == "0"
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.end,
                      children: [
                        if (orders[i].products[index].size == "0")
                          Row(
                            children: [
                              Text(
                                "Size: ",
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${orders[i].products[index].size}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Text(
                              "Color: ",
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.4 / 4,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).accentColor,
                                ),
                                color: orders[i].products[index].color,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
