import 'package:flutter/material.dart';

progressDialog(BuildContext context) {
  showGeneralDialog(
      barrierDismissible: false,
      barrierColor: Colors.black45.withOpacity(0.65),
      barrierLabel: "",
      context: context,
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) => Center(
            child: CircularProgressIndicator(),
          ));
}
