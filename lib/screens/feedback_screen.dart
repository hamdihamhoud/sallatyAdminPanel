import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/widgets/feedback_tile.dart';
import 'package:adminpanel/widgets/web_drawer.dart';
import 'package:provider/provider.dart';
import '../models/feedback.dart' as fb;
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  static const routeName = '/feedback';
  FeedbackScreen({Key key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<fb.Feedback> feedbacks = [];
  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminFunctioins>(context);
    final theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: WebDrawer(
              selectedIndex: 2,
            ),
          ),
          Expanded(
            flex: 5,
            child: FutureBuilder(
              future: adminProvider.getAllFeedbacksNotSeen(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                feedbacks = snapshot.data;
                return feedbacks != null && feedbacks.length > 0
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'User',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text('Feedback',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w600
                                  ),),
                                Text('Mark as seen',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w600
                                  ),),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: feedbacks.length,
                                itemBuilder: (ctx, index) =>
                                    FeedbackTile(feedbacks[index])),
                          ),
                        ],
                      )
                    : Center(child: Text('No Feedbacks'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
