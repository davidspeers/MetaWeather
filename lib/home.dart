import 'package:flutter/material.dart';
import 'models/post.dart';
import 'components/posts_list_view.dart';
import 'components/toasts.dart';
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
        future: fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error.runtimeType == SocketException) {
              blueGreyToast("MetaWeather Server Error");
            } else {
              blueGreyToast("${snapshot.error.runtimeType} Error");
            }
            return PostsListView(posts: []);
          }

          if (snapshot.hasData && snapshot.data.isEmpty) {
            blueGreyToast("No Internet Connection");
          }

          return snapshot.hasData
              ? PostsListView(posts: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}