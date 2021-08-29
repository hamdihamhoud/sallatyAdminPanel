import 'package:adminpanel/providers/orders.dart';
import 'package:adminpanel/screens/orders_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

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
      padding: const EdgeInsets.all(30),
      child: Container(
        decoration: BoxDecoration(
          color: theme.accentColor,
          border: Border.all(
            color: theme.accentColor,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        width: double.infinity,
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
                    ordersProvider
                        .deleteOrderItemFromOrder(orders[i].products[index].id),
                    Navigator.of(context)
                        .pushReplacementNamed(OrdersScreen.routeName),
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
                              width: size.width / 4 * 0.8,
                              height: 90,
                              imageUrl: orders[i].products[index].imageUrl,
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
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Quantity: ',
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Text(
                                  orders[i]
                                      .products[index]
                                      .quantity
                                      .toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Color(0xFF3333333),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                              width: MediaQuery.of(context).size.width * 0.05,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                border: Border.all(
                                  width: 2,
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
