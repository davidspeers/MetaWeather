import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void blueGreyToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.blueGrey,
    textColor: Colors.white,
  );
}
