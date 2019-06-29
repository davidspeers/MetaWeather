import 'package:flutter/material.dart';
import 'models/post.dart';
import 'components/posts_list_view.dart';
import 'components/toasts.dart';
import 'utils/constants.dart';
import 'dart:io';

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Post>>(
        future: fetchPosts(BELFAST_WOE_ID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error.runtimeType == SocketException) {
              blueGreyToast(SOCKET_EXCEPTION_MSG);
            } else {
              blueGreyToast("${snapshot.error.runtimeType} Error");
            }
            return PostsListView(posts: []);
          }

          if (snapshot.hasData && snapshot.data.isEmpty) {
            blueGreyToast(NO_INTERNET_MSG);
          }

          return snapshot.hasData
              ? PostsListView(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}