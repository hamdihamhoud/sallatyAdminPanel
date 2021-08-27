import 'package:adminpanel/providers/admin_functions.dart';
import 'package:adminpanel/screens/feedback_screen.dart';
import 'package:provider/provider.dart';

import '../models/feedback.dart' as fb;
import 'package:flutter/material.dart';

class FeedbackTile extends StatelessWidget {
  final fb.Feedback feedback;
  FeedbackTile(this.feedback);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(feedback.user.name),
      title: Text(feedback.feedback,textAlign: TextAlign.center,),

      trailing: IconButton(
        icon: Icon(
          Icons.check_circle_outline_outlined,
        ),
        onPressed: () async {
         await Provider.of<AdminFunctioins>(context,listen: false).setFeedbacksToSeen(feedback.id, feedback.user.id);
         Navigator.of(context).pushReplacementNamed(FeedbackScreen.routeName);   
        },
      ),
    );
  }
}
