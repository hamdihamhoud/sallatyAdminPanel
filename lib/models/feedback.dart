import 'package:adminpanel/models/user_data.dart';
import 'package:flutter/cupertino.dart';

class Feedback {
  final String id;
  final String feedback;
  final UserData user;

  Feedback({
    @required this.id,
    @required this.feedback,
    @required this.user,
  });
}
